import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';
import elmWebComponents from '@teamthread/elm-web-components'

elmWebComponents.configure('0.19');

elmWebComponents.register('elm-rating', Elm.Main, {
  setupPorts: ports => {
    ports.ratingChanged.subscribe(data => {
      alert(JSON.stringify(data));
    })
  },
  onSetupError: error => {
    alert('elmWebComponents -> Something went wrong', error)
  }
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
