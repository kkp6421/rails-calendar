import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../components/home.vue'
import About from '../components/about.vue'
import Contact from '../components/contact.vue'
import Login from '../components/login.vue'
import CreateUser from '../components/createUser.vue'
import NotFound from '../components/notFound.vue'
import auth from '../auth/auth'

Vue.use(VueRouter)

export default new VueRouter({
    mode: 'history',
    routes: [
        {
            path: '/',
            component: Home,
            beforeEnter: function(to, from, next){
                if(!auth.loggedIn()){
                    next({
                        path: '/login',
                        query: { redirect: to.fullPath }
                    })
                }else{
                    next()
                }
            }
        },
        {
            path: '/about',
            component: About
        },
        {
            path: '/contact',
            component: Contact
        },
        {
            path: '/login',
            component: Login,
            beforeEnter: function(to, from, next){
                if(auth.loggedIn()){
                    next({
                        path: '/',
                        query: { redirect: to.fullPath }
                    })
                    //alert("ログイン済みです。")
                }else{
                    next()
                }
            }

        },
        {
            path: '/logout',
            beforeEnter: function (to, from, next) {
                if(auth.loggedIn()){
                    auth.logout()
                    next({
                        path: '/login',
                        query: { redirect: to.fullPath }
                    })
                }else{
                    next({
                        path: '/',
                        query: { redirect: to.fullPath }
                    })
                }
            }
        },
        {
            path: '/users/new',
            component: CreateUser,
            beforeEnter: function(to, from, next){
                if(auth.loggedIn()){
                    next({
                        path: '/',
                        query: { redirect: to.fullPath }
                    })
                    alert("一旦ログアウトしてください。")
                }else{
                    next()
                }
            }

        },
        {
            path: '*',
            component: NotFound
        }
    ],
})
