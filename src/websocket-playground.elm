import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import Json.Decode as Decode
import Json.Encode as Encode exposing (..)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Bootstrap.Form.Input as Input
import Bootstrap.Form.InputGroup as InputGroup
import Bootstrap.Button as Button
import Dict exposing (get, keys)
import Result exposing (..)
import Maybe
import Debug

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


echoServer : String -> String
echoServer username =
  "ws://localhost:9000/websocket/" ++ username



-- MODEL


type alias Model =
  { input : String
  , messages : List String
  }


init : (Model, Cmd Msg)
init =
  (Model "" [], Cmd.none)

username : String
username = "Donovan"

-- UPDATE


type Msg
  = Input String
  | Send
  | NewMessage String


update : Msg -> Model -> (Model, Cmd Msg)
update msg {input, messages} =
  case msg of
    Input newInput ->
      (Model newInput messages, Cmd.none)

    Send -> 
      (Model "" messages, WebSocket.send (echoServer username) (encode 0 (getMessage input)))

    NewMessage str ->
      Debug.log(str)
      (Model input (((withDefault "" (Decode.decodeString getUserName str)) ++ ": " ++ (withDefault "" (Decode.decodeString getNewMessage str))) :: messages), Cmd.none)

getUserName: Decode.Decoder String     
getUserName =
  Decode.field "data" (Decode.field "username" Decode.string)

getNewMessage : Decode.Decoder String
getNewMessage =
  Decode.field "data" (Decode.field "message" Decode.string)

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen (echoServer username) NewMessage



-- VIEW


view : Model -> Html Msg
view model =
  Grid.container []
    [ CDN.stylesheet
    , Grid.row
        [ Row.topXs ]
        [ Grid.col
            [ Col.xs4 ] 
            [ div [] (List.map viewMessage (List.reverse model.messages)) ]

        , Grid.col
            [ Col.xs8 ]
            [
              InputGroup.config
                ( InputGroup.text
                [ Input.id "message"
                , Input.placeholder "Message"
                , Input.onInput Input
                , Input.value model.input
                ]
              )
              |> InputGroup.successors
                  [ InputGroup.button [ Button.primary, Button.onClick Send ] [ text "Send"] ]
              |> InputGroup.view    
            ]
        ]
    ]

viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]

getMessage : String -> Encode.Value
getMessage msg =
  Encode.object
    [ ("type", string "message")
    ,  ("data", Encode.object 
      [ ("message", string msg)
      , ("username", string username)
      ]
      )
    ]

