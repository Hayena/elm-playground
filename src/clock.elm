module DigitalClock exposing (clock)


import Html exposing (Html)
import Html.Attributes as HA exposing (style)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Date as D exposing (..)
import Time as T exposing (..)

main =
  Html.program { 
    init = init, 
    view = view,
    update = update,
    subscriptions = subscriptions
  }

type alias Model = T.Time


init : (Model, Cmd Msg)
init =
  (0, Cmd.none)

type Msg = Tick T.Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick time ->
      (time, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  T.every T.second Tick

view : Model -> Html Msg
view model =
  clock model

leadingZero: Int -> String
leadingZero t = 
  if t < 10 then
    "0" ++ (toString t)
  else
    toString t

currentTime: Time -> String
currentTime t =
  let date_ = fromTime t
      hour_ = leadingZero (D.hour date_)
      minute_ = leadingZero (D.minute date_)
      second_ = leadingZero (D.second date_)
      now = hour_ ++ ":" ++ minute_ ++ ":" ++ second_
  in
    now

prettifyText: String -> Svg msg
prettifyText string =
  text_ [ HA.style [ ("fill", "rgb(255, 255, 255)")
                   , ("fontSize", "120px")
                   , ("fontFamily", "alarm clock")
                   ]
        , x "300"
        , y "195"
        , textAnchor "middle"
        ] [ text string ]

rectStyle: List (Attribute msg)
rectStyle = 
  [ width "600"
  , height "300"
  , fill "rgb(0, 0, 0)"
  , stroke "rgb(31, 31, 31)"
  , strokeWidth "10" ]

clock: Time -> Html msg
clock t =
  svg
    [ width "600", height "300", viewBox "0 0 600 300" ]
    [ rect rectStyle []
    , prettifyText (currentTime t)]