<template>
    <div>
        <v-form ref="form" lazy-validation>
            <br/>
            <v-text-field v-model="email" :rules="emailRules" label="メールアドレス" required></v-text-field>
            <v-text-field
                    v-model="password"
                    :append-icon="show?'mdi-eye':'mdi-eye-off'"
                    :rules="[passwordRules.required, passwordRules.min]"
                    :type="show ? 'text' : 'password'"
                    name="input-10-1"
                    label="パスワード"
                    hint="最低六文字です。"
                    counter
                    @click:append="show = !show"
            ></v-text-field>
            <v-btn
                    color="cyan"
                    class="mr-4"
                    @click="login"
                    style="color: white;"
            >ログイン</v-btn><br/>
            <span style="color: #d9534f; font-size: 0.7rem;" v-show="error">メールアドレスまたはパスワードが違います。</span>
        </v-form>
    </div>
</template>

<script>
    import auth from '../auth/auth'
    const required = val => !!val.trim()
    const REGEX_EMAIL = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    export default {
        data: function () {
            return {
                show: false,
                error: false,
                email: '',
                password: '',
                error: false,
                emailRules: [
                    v => !!v || 'メールアドレスを入力してください。',
                    v => /.+@.+\..+/.test(v) || 'メールアドレスの形式が不正です。',
                ],
                passwordRules: {
                    required: value => !!value || 'メールアドレスを入力してください。',
                    min: v => v.length >= 6 || '最低六文字です。',
                    emailMatch: () => ('The email and password you entered don\'t match'),
                },
            }
        },
        computed: {
            validation: function () {
                return {
                    email: {
                        required: required(this.email),
                        format: REGEX_EMAIL.test(this.email)
                    },
                    password: {
                        required: required(this.password)
                    }
                }
            },
        },
        methods: {
            login: function() {
                if(!this.validation.email.required){
                    return
                }
                if(!this.validation.email.format){
                    return
                }
                if(!this.validation.password.required){
                    return
                }
                let _this = this
                auth.login(this.email, this.password, function (loggedIn) {
                    if(!loggedIn){
                        _this.error = true
                    }else{
                        _this.$router.push('/')
                    }
                })
            },
            validate: function () {
                this.$refs.form.validate()
            }
        }
    }
</script>
