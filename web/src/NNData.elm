module NNData exposing (..)

import Json.Decode exposing (Decoder, index, map2)


nnDataDecoder : Decoder NNData
nnDataDecoder =
    Json.Decode.map NNData
        (Json.Decode.at [ "content" ]
            (Json.Decode.list
                (map2
                    (\a b ->
                        ( a
                        , b
                        )
                    )
                    (index 0 Json.Decode.float)
                    (index 1 Json.Decode.float)
                )
            )
        )


type alias NNData =
    { content : List ( Float, Float )
    }
