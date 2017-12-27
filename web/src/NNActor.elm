port module NNActor exposing (..)

import NNData exposing (NNData, encodeNNData, nnDataDecoder)
import Json.Decode exposing (decodeValue)
import Json.Encode


sendData : DataOut -> Cmd msg
sendData data =
    case data of
        NoOp ->
            Cmd.none

        PageReady ->
            dataOut { tag = "PageReady", data = Json.Encode.null }

        LogError err ->
            dataOut { tag = "LogError", data = Json.Encode.string err }


type DataIn
    = NewData NNData


type DataOut
    = NoOp
    | PageReady
    | LogError String


type alias GenericOutsideData =
    { tag : String, data : Json.Encode.Value }


port dataIn : (GenericOutsideData -> msg) -> Sub msg


port dataOut : GenericOutsideData -> Cmd msg


receiveData : (DataIn -> msg) -> (String -> msg) -> Sub msg
receiveData dataHandler errorHandler =
    dataIn
        (\outsideInfo ->
            case outsideInfo.tag of
                "NewData" ->
                    case decodeValue (nnDataDecoder) outsideInfo.data of
                        Ok entries ->
                            dataHandler <| NewData entries

                        Err e ->
                            errorHandler e

                _ ->
                    errorHandler <| "Unexpected info from outside: " ++ toString outsideInfo
        )
