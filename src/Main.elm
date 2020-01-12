module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



---- MODEL ----


type alias Model =
    { title : String
    , rating : Maybe Rating
    }


type Rating
    = One
    | Two
    | Three
    | Four
    | Five


ratingToNumber : Maybe Rating -> Int
ratingToNumber rating =
    case rating of
        Nothing ->
            0

        Just One ->
            1

        Just Two ->
            2

        Just Three ->
            3

        Just Four ->
            4

        Just Five ->
            5


numberToRating : Int -> Maybe Rating
numberToRating number =
    case number of
        1 ->
            Just One

        2 ->
            Just Two

        3 ->
            Just Three

        4 ->
            Just Four

        5 ->
            Just Five

        _ ->
            Nothing


init : ( Model, Cmd Msg )
init =
    ( { title = "A fancy title"
      , rating = Nothing
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = StarClicked (Maybe Rating)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StarClicked newRating ->
            ( { model | rating = newRating }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        emptyStar index =
            span [ style "cursor" "pointer", onClick (StarClicked (numberToRating index)) ] [ text "☆" ]

        filledStar index =
            span [ style "cursor" "pointer", style "color" "yellow", onClick (StarClicked (numberToRating index)) ] [ text "★" ]

        ( numberOfFilledStars, numberOfEmptyStars ) =
            let
                numberOfFilled =
                    ratingToNumber model.rating
            in
            ( numberOfFilled, 5 - numberOfFilled )

        renderedFilledStars =
            List.range 1 numberOfFilledStars
                |> List.map filledStar

        renderedEmptyStars =
            List.range (numberOfFilledStars + 1) (numberOfFilledStars + numberOfEmptyStars)
                |> List.map emptyStar

        renderedStars =
            renderedFilledStars ++ renderedEmptyStars
    in
    div [ style "background-color" "lightgrey", style "width" "200px", style "display" "flex", style "flex-direction" "column", style "align-items" "center" ]
        [ h2 [] [ text model.title ]
        , div [ style "display" "flex", style "font-size" "3rem" ]
            renderedStars
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
