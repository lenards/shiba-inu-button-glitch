module Main exposing (main)

import Browser exposing (Document)
import Html exposing (Html)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder)



type Msg
  = Fetch
  | Receive (Result Http.Error String)


type alias Model =
  { imageSrc : Maybe String
  }


placeholder =
  "https://cdn.glitch.com/81b9dece-377a-44ea-a459-e294d0cb882d%2Fplaceholder-image.png?v=1570836239423"


dogDecoder = 
  Decode.field "message" Decode.string


apiUrl breed =
  [ "https://dog.ceo/api/breed/", breed, "/images/random" ]


createApiUrl =
  String.join "" (apiUrl "shiba")


fetchDog =
  Http.get
    { url = createApiUrl
    , expect = Http.expectJson Receive dogDecoder
    }


update msg model =
  case msg of 
    Fetch -> 
      ( model, fetchDog )

    Receive (Ok imageSrc) ->
      ( { model | imageSrc = Just imageSrc }
      , Cmd.none 
      )

    Receive (Err error) ->
      ( model, Cmd.none )


renderView model =
  [ div [ class "container" ]
    [ header [] [ h1 [] [ text "Shiba Button!" ] ]
    , main_ [] 
        [ div [ class "content"] 
            [ div [] 
                [img 
                  [ src (model.imageSrc |> Maybe.withDefault placeholder)
                  , alt "Random Shiba inu picture"] 
                  []
                ]
            , div [ style "padding-top" "12px" ] 
                [ button [ onClick Fetch ] [ text "Gimme a Shiba!" ]
                ]
            ]
        ]
    , footer [] 
        [ h2 [ style "color" "ff6400" ] [ text "Acknowledgments!" ]
        , p [] 
            [ text "Poodles provided by ", a [ href "https://dog.ceo/dog-api/" ] [ text "dog.ceo API" ], text "."
            , br [] []
            , text "Inspired by ", a [ href "http://corgi-button.glitch.me" ] [ text "Corgi Button" ], text "."
            , br [] []
            , text "Code and hosting by ", a [ href "https://glitch.com/edit/#!/shiba-inu-button" ] [ text "Glitch" ], text "."
            , br [] []
            , text "Made in 2019"
            ]
        ]
    ]
  ]


view model =
  { title = "Shiba Button!"
  , body = renderView model
  }


init : () -> ( Model, Cmd Msg )
init _ =
  ( { imageSrc = Nothing }
  , fetchDog
  )


main =
    Browser.document
      { init = init
      , view = view
      , update = update
      , subscriptions = (\_ -> Sub.none)
      }  
