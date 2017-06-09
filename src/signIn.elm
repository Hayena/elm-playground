import Html exposing (Html, div, input, text, button)
import Bootstrap.CDN as CDN
import Bootstrap.Form.Input as Input
import Bootstrap.Form.InputGroup as InputGroup
import Bootstrap.Button as Button

main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }



-- MODEL


type alias Model =
  { username : String
  }


model : Model
model =
  Model ""



-- UPDATE


type Msg
  = Change String
  | Connect

update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { model | username = newContent }
    Connect ->
     { model | username = "" }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ CDN.stylesheet
    , InputGroup.config
    ( InputGroup.text
      [ Input.id "username"
      , Input.placeholder "Fill in your username"
      , Input.onInput Change
      ]
    )
    |> InputGroup.successors
        [ InputGroup.button [ Button.primary ] [ text "Connect"] ]
    |> InputGroup.view
    , div [] [ text (model.username) ]
    ]