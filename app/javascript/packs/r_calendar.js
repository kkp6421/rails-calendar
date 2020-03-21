import Vue from 'vue'
import Vuetify from 'vuetify'
import 'vuetify/dist/vuetify.min.css'
import App from '../app.vue'
import Router from './router/router'

Vue.use(Vuetify)
const vuetify = new Vuetify()

document.addEventListener('DOMContentLoaded', () => {
    const app = new Vue({
        router: Router,
        vuetify,
        render: h => h(App)
    }).$mount()
    document.body.appendChild(app.$el)
})
