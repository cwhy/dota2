module Main exposing (..)

import Html exposing (Html, div, text, program)
import NNActor exposing (DataIn(NewData), sendData, receiveData, DataOut(PageReady, LogError))


-- MODEL


type alias Model =
    { title : String
    , data : String
    }


init : ( Model, Cmd Msg )
init =
    ( { title = "Dota2 Hero Explorer", data = "" }, Cmd.none )



-- MESSAGES


type Msg
    = NoOp
    | Outside DataIn
    | LogErr String



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model.title ]
        , div [] [ text model.data ]
        ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Outside dataIn ->
            case dataIn of
                NewData newData ->
                    { model | data = newData.content } ! [ sendData PageReady ]

        LogErr err ->
            model ! [ sendData (LogError err) ]



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
