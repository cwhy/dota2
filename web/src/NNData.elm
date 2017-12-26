module NNData exposing (..)

import Json.Decode exposing (Decoder)
import Json.Encode


nnDataDecoder : Decoder NNData
nnDataDecoder =
    Json.Decode.map NNData
        (Json.Decode.at [ "content" ] Json.Decode.string)


encodeNNData : NNData -> Json.Encode.Value
encodeNNData nnData =
    Json.Encode.object
        [ ( "content", Json.Encode.string nnData.content ) ]


type alias NNData =
    { content : String
    }
