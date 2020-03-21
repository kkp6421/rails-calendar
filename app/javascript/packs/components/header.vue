<template>
    <div>
        <v-card color="grey lighten-4" tile style="background-color: #ff6f00;">
            <v-toolbar dark>

                <v-toolbar-title>
                    <router-link to="/" style="color: white; text-decoration: none;">
                        R-Calendar
                    </router-link>
                </v-toolbar-title>

                <v-spacer></v-spacer>
                <v-btn icon style="padding: 0px 30px;">
                    <router-link to="/about" style="color: white; text-decoration: none;">
                        <v-icon>mdi-file</v-icon><br/>
                        <span style="font-size: 0.6rem;">使い方</span>
                    </router-link>
                </v-btn>
                <v-btn icon style="padding: 0px 30px;">
                    <router-link to="/contact" style="color: white; text-decoration: none;">
                        <v-icon>mdi-phone-forward</v-icon><br/>
                        <span style="font-size: 0.6rem;">連絡先</span>
                    </router-link>
                </v-btn>
                <v-btn icon style="padding: 0px 30px;" v-show="!!token">
                    <router-link to="/logout" style="color: white; text-decoration: none;">
                        <v-icon>mdi-logout</v-icon><br/>
                        <span style="font-size: 0.6rem;">ログアウト</span>
                    </router-link>
                </v-btn>
                <v-btn icon style="padding: 0px 30px;" v-show="!token">
                    <router-link to="/users/new" style="color: white; text-decoration: none;">
                        <v-icon>mdi-account-plus</v-icon><br/>
                        <span style="font-size: 0.6rem;">新規登録</span>
                    </router-link>
                </v-btn>

            </v-toolbar>
        </v-card>
    </div>
</template>

<script>
    import auth from '../auth/auth'
    export default {
        data: function () {
            return {
                token: localStorage.token,
                auth: auth,
                bars: { class: '', dark: true }
            }
        },
        created: function(){
            this.fetchToken()
        },
        watch: {
            '$route': 'fetchToken'
        },
        methods: {
            fetchToken: function(){
                this.token = localStorage.token
            }
        }
    }
</script>
