<template>
    <div>
        <v-form ref="form" lazy-validation>
            <br/>
            <v-text-field
                    v-model="email"
                    :rules="emailRules"
                    label="メールアドレス"
                    required>
            </v-text-field>
            <v-text-field
                    v-model="password"
                    :append-icon="show?'mdi-eye':'mdi-eye-off'"
                    :rules="[passwordRules.required, passwordRules.min]"
                    :type="show ? 'text' : 'password'"
                    name="input-10-1"
                    label="パスワード"
                    hint="最低六文字です。"
                    @click:append="show = !show"
            ></v-text-field>
            <v-text-field
                    v-model="password_confirmation"
                    :append-icon="show?'mdi-eye':'mdi-eye-off'"
                    :rules="[passwordConfirmationRules.required, passwordConfirmationRules.match]"
                    :type="show ? 'text' : 'password'"
                    name="input-10-2"
                    label="パスワード確認"
                    @click:append="show = !show"
            ></v-text-field>
            <v-btn
                    color="cyan"
                    class="mr-4"
                    @click="createUser"
                    style="color: white;"
            >アカウント作成</v-btn><br/>
            <span style="color: #d9534f; font-size: 0.7rem;" v-show="error">このメールアドレスはすでに使われています。</span>
        </v-form>
    </div>
</template>

<script>
    import axios from 'axios'
    const required = val => !!val.trim()
    const REGEX_EMAIL = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    export default {
        data: function () {
            return {
                show: false,
                error: false,
                email: '',
                password: '',
                password_confirmation: '',
                emailRules: [
                    v => !!v || 'メールアドレスを入力してください。',
                    v => /.+@.+\..+/.test(v) || 'メールアドレスの形式が不正です。',
                ],
                passwordRules: {
                    required: value => !!value || 'メールアドレスを入力してください。',
                    min: v => v.length >= 6 || '最低六文字です。',
                },
                passwordConfirmationRules: {
                    required: value => !!value || 'パスワードを入力してください。',
                    match: v => v.trim()===this.password.trim() || 'パスワードと違います。',
                }
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
                        required: required(this.password),
                        length: this.password.length >= 6
                    },
                    password_confirmation: {
                        required: required(this.password_confirmation),
                        match: this.password.trim() === this.password_confirmation.trim()
                    }
                }
            },
        },
        methods: {
            createUser: function () {
                if(!this.validation.email.required){
                    return
                }
                if(!this.validation.email.format){
                    return
                }
                if(!this.validation.password.required){
                    return
                }
                if(!this.validation.password_confirmation.required){
                    return
                }
                if(!this.validation.password_confirmation.match){
                    return
                }
                let _this = this
                axios.defaults.headers.common["Authorization"] = `Bearer ${localStorage.token}`;
                axios.post('/api/users/new/', {
                    user: {email: this.email, password: this.password, password_confirmation: this.password_confirmation }
                }).then(response => {
                    _this.$router.push('/login')
                }).catch(response => {
                    this.error = true
                    console.log(response)
                })
            }
        }
    }
</script>
