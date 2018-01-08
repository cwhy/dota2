module Main exposing (..)

import Html exposing (Html, div, text, program, input)
import Html.Attributes as H exposing (..)
import Html.Events exposing (onInput)
import NNActor exposing (DataIn(NewHeroVecs), sendData, receiveData, DataOut(PageReady, LogError))
import Plot exposing (..)
import Svg exposing (Svg)
import Svg.Attributes exposing (xlinkHref, stroke, strokeDasharray, r, fill, strokeWidth)
import Svg.Events exposing (onMouseOver, onMouseOut)
import Round
import Heros exposing (..)
import String exposing (dropLeft, dropRight)


-- MODEL


defaultIconSize : Float
defaultIconSize =
    50


type alias Model =
    { title : String
    , heros : List Hero
    , rangeFrameHover : Maybe Point
    , iconSize : Float
    }


init : ( Model, Cmd Msg )
init =
    ( { title = "Dota2 Hero Explorer"
      , heros = initHeros
      , rangeFrameHover = Nothing
      , iconSize = defaultIconSize
      }
    , Cmd.none
    )



-- MESSAGES


type Msg
    = NoOp
    | Outside DataIn
    | LogErr String
    | HoverRangeFrame (Maybe Point)
    | Slide String



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model.title ]
        , input
            [ H.type_ "range"
            , H.value <| toString model.iconSize
            , onInput Slide
            , H.min "10"
            , H.max "50"
            ]
            []
        , div []
            [ viewPlot
                model.iconSize
                model.rangeFrameHover
                model.heros
            ]
        ]


scatter : Float -> Maybe Point -> Series (List Hero) Msg
scatter iconSize hinting =
    { axis = rangeFrameAxis hinting .y
    , interpolation = None
    , toDataPoints = List.map (rangeFrameHintDot iconSize hinting)
    }


heroLabel : String -> Float -> Float -> Svg Msg
heroLabel label x y =
    Svg.text_
        [ fill blueStroke
        , onMouseOver (HoverRangeFrame (Just { x = x, y = y }))
        , onMouseOut (HoverRangeFrame Nothing)
        ]
        [ Svg.tspan [] [ Svg.text label ] ]


heroIcon : Float -> String -> Float -> Float -> Svg Msg
heroIcon iconSize iconUrl x y =
    Svg.image
        [ Svg.Attributes.x (toString x)
        , Svg.Attributes.y (toString y)
        , Svg.Attributes.width <| (toString iconSize) ++ "px"
        , xlinkHref (baseImgUrl ++ iconUrl)
        ]
        []


flashyLine : Float -> Float -> Point -> Maybe (AxisSummary -> LineCustomizations)
flashyLine x y hinted =
    if hinted.x == x && hinted.y == y then
        Just (fullLine [ stroke "#a3a3a3", strokeDasharray "2, 10" ])
    else
        Nothing


rangeFrameHintDot : Float -> Maybe Point -> Hero -> DataPoint Msg
rangeFrameHintDot iconSize hinted hero =
    let
        ( x, y ) =
            case hero.vec of
                NoPosition ->
                    ( 0, 0 )

                Position { x, y } ->
                    ( x, y )

        icon =
            hero.iconUrl
    in
        { view = Just (heroIcon iconSize icon x y)
        , xLine = Maybe.andThen (flashyLine x y) hinted
        , yLine = Maybe.andThen (flashyLine x y) hinted
        , xTick = Just (simpleTick x)
        , yTick = Just (simpleTick y)
        , hint = Nothing
        , x = x
        , y = y
        }


toShortString : Float -> String
toShortString x =
    x |> Round.round 3 |> toString |> dropRight 1 |> dropLeft 1


customLabel : Float -> LabelCustomizations
customLabel position =
    { position = position
    , view = viewLabel [] ((toShortString position))
    }


minmaxLabel : Float -> LabelCustomizations
minmaxLabel position =
    { position = position
    , view = viewLabel [] ((toShortString position))
    }


rangeFrameAxis : Maybe Point -> (Point -> Float) -> Axis
rangeFrameAxis hinted toValue =
    customAxis <|
        \summary ->
            { position = closestToZero
            , axisLine = Nothing
            , ticks = List.map simpleTick [ summary.dataMin, summary.dataMax ]
            , labels =
                List.map minmaxLabel [ summary.dataMin, summary.dataMax ]
                    ++ hintLabel hinted toValue
            , flipAnchor = False
            }


blueStroke : String
blueStroke =
    "#3eafdf"


hintLabel : Maybe Point -> (Point -> Float) -> List LabelCustomizations
hintLabel hinted toValue =
    hinted
        |> Maybe.map (toValue >> customLabel >> List.singleton)
        |> Maybe.withDefault []


viewPlot : Float -> Maybe Point -> List Hero -> Svg.Svg Msg
viewPlot iconSize hinting data =
    viewSeriesCustom
        { defaultSeriesPlotCustomizations
            | horizontalAxis = rangeFrameAxis hinting .x
            , width = 1000
            , height = 800
            , margin = { top = 20, bottom = 20, left = 40, right = 40 }
            , toRangeLowest = \y -> y - 0.02
            , toDomainLowest = \y -> y - 1
        }
        [ scatter iconSize hinting ]
        data



-- UPDATE


updateHero : Hero -> ( Float, Float ) -> Hero
updateHero hero ( x, y ) =
    { hero | vec = Position { x = x, y = y } }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Outside dataIn ->
            case dataIn of
                NewHeroVecs newHeroVecs ->
                    { model | heros = List.map2 updateHero model.heros newHeroVecs.content } ! [ sendData PageReady ]

        HoverRangeFrame point ->
            { model | rangeFrameHover = point } ! []

        LogErr err ->
            model ! [ sendData (LogError err) ]

        Slide sliderInput ->
            case String.toFloat sliderInput of
                Ok iconSize ->
                    { model | iconSize = iconSize } ! []

                Err _ ->
                    { model | iconSize = defaultIconSize } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    receiveData Outside LogErr



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
