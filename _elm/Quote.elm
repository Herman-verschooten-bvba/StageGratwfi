module Quote exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (class)
import List.Extra as List
import Random


type alias Quote =
    { name : String
    , quote : String
    }


type alias Model =
    Quote


quotes : String -> List Quote
quotes locale =
    case locale of
        "nl" ->
            [ Quote "Gust" "Aapjes&reg; eten graag nootjes"
            ]

        "fr" ->
            []

        _ ->
            []


quote : String -> Int -> Quote
quote locale index =
    List.getAt index (quotes locale)
        |> Maybe.withDefault (Quote "Gaston" "TESTKE")


view : Model -> Html Msg
view model =
    Html.div [ class "quote" ]
        [ Html.blockquote []
            [ Html.p []
                [ Html.text model.quote
                ]
            , Html.p [ class "quotee" ]
                [ Html.text model.name
                ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


type Msg
    = NoOp


type alias Config =
    { seed : Int
    , locale : String
    }


init : Config -> ( Model, Cmd Msg )
init config =
    let
        locale =
            config.locale

        seed0 =
            Random.initialSeed config.seed

        local_quotes =
            quotes locale

        upper_limit =
            (List.length local_quotes) - 1

        ( index, _ ) =
            Random.step (Random.int 0 upper_limit) seed0
    in
        ( quote locale index, Cmd.none )


main : Program Config Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
