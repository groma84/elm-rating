port module Main exposing (..)

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


type alias StarCounts =
    { numberOfFilledStars : Int
    , numberOfEmptyStars : Int
    }


ratingToStarCounts : Maybe Rating -> StarCounts
ratingToStarCounts rating =
    case rating of
        Nothing ->
            StarCounts 0 5

        Just One ->
            StarCounts 1 4

        Just Two ->
            StarCounts 2 3

        Just Three ->
            StarCounts 3 2

        Just Four ->
            StarCounts 4 1

        Just Five ->
            StarCounts 5 0


type alias Flags =
    { title : String
    , rating : Maybe String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        parsedRating =
            let
                parsedString =
                    Maybe.andThen String.toInt flags.rating
            in
            Maybe.andThen numberToRating parsedString
    in
    ( { title = flags.title
      , rating = parsedRating
      }
    , Cmd.none
    )



---- PORTS ----


ratingToString : Rating -> String
ratingToString rating =
    case rating of
        One ->
            "1"

        Two ->
            "2"

        Three ->
            "3"

        Four ->
            "4"

        Five ->
            "5"


port ratingChanged : Flags -> Cmd msg



---- UPDATE ----


type Msg
    = StarClicked Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StarClicked clickedIndex ->
            let
                newRating =
                    numberToRating clickedIndex

                ratingAsString =
                    Maybe.map ratingToString newRating

                ratingChangedPortCmd =
                    ratingChanged { title = model.title, rating = ratingAsString }
            in
            ( { model | rating = newRating }, ratingChangedPortCmd )



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        -- HTML-Element für leeren Stern
        emptyStar index =
            span [ style "cursor" "pointer", onClick (StarClicked index) ] [ text "☆" ]

        -- HTML-Element für gefüllten Stern
        filledStar index =
            span [ style "cursor" "pointer", style "color" "yellow", onClick (StarClicked index) ] [ text "★" ]

        -- wieviele Sterne von welcher Art werden benötigt?
        { numberOfFilledStars, numberOfEmptyStars } =
            ratingToStarCounts model.rating

        -- alle DOM-Elemente für die gefüllten Sterne
        renderedFilledStars =
            -- Liste mit Zahlen: [1..n]
            List.range 1 numberOfFilledStars
                -- Für jede Zahl einmal die HTML-Element-Funktion mit der Zahl als zusätzliches Argument aufrufen
                |> List.map filledStar

        -- alle DOM-Elemente für die leeren Sterne
        renderedEmptyStars =
            List.range (numberOfFilledStars + 1) (numberOfFilledStars + numberOfEmptyStars)
                |> List.map emptyStar

        -- Liste mit allen notwendigen Stern-DOM-Elementen erzeugen
        allRenderedStars =
            renderedFilledStars ++ renderedEmptyStars
    in
    div [ class "elm-rating__wrapper" ]
        [ h2 [] [ text model.title ]
        , div [ class "elm-rating__star-container" ] allRenderedStars
        ]



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }