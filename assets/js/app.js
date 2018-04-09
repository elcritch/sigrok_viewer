// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

import "babel-polyfill";
import 'babel-runtime/core-js/object/assign';
import 'babel-runtime/helpers/slicedToArray';
import 'babel-runtime/core-js/array/concat';
import 'babel-runtime/core-js/json/stringify';
import 'babel-runtime/helpers/toConsumableArray';
import 'babel-runtime/helpers/defineProperty';

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"


// import Vue from 'vue';
import iView from 'iview';
import locale from 'iview/dist/locale/en-US';

Vue.use(iView, {locale});

// import VueScrollMonitor from 'vue-scrollmonitor'
// Vue.use(VueScrollMonitor)

import TestComponent from './TestComponent.vue';


new Vue({
    el: '#vue-app',
    data: {
        message: "Hello World"
    },
    components: {
        'test-component': TestComponent,
    },
});

