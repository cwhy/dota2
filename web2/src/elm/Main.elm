module Main exposing (Model, Msg(..), init, main, update, viewBody, viewPage)

import Browser
import Element as UI
import Element.Input as Input
import Html exposing (Html)



---- MODEL ----


type alias Flags =
    { logoUrl : String
    }


type alias Model =
    { title : String
    , content : String
    , initFlags : Flags
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { title = "New App"
      , content = "App is Working"
      , initFlags = flags
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = SetContent String


noCmd : Model -> ( Model, Cmd Msg )
noCmd model =
    ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetContent content ->
            { model | content = content } |> noCmd



---- VIEW ----


viewBody : Model -> UI.Element Msg
viewBody model =
    UI.column
        [ UI.centerX ]
        [ UI.image []
            { src = model.initFlags.logoUrl
            , description = "Logo"
            }
        , UI.text model.content
        , Input.text
            []
            { onChange = SetContent
            , text = model.content
            , placeholder = Just (Input.placeholder [] (UI.text model.content))
            , label = Input.labelAbove [] UI.none
            }
        ]


viewPage : Model -> Browser.Document Msg
viewPage model =
    { title = model.title
    , body = [ UI.layout [] (viewBody model) ]
    }



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.document
        { view = viewPage
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
