<template>
    <div>
        <v-row>
            <v-col cols="12" sm="6" class="my-2 px-1">
                <v-date-picker
                        ref="picker"
                        color="light-green accent-4"
                        v-model="selectedDate"
                        :events="TasksSelectedDate"
                        locale="ja"
                        full-width
                ></v-date-picker>
            </v-col>
            <v-col cols="12" sm="6" class="my-2 px-1">
                <v-card ontlined>
                    <div class="title" style="width: 100%; background-color: #00BCD4; padding: 14px; color: white;">{{ selectedDate }}のタスク</div>
                    <ul class="ma-4" style="position: relative; bottom: 30px;">
                        <v-row>
                            <v-col cols="10" sm="11" class="my-2 px-1">
                                <v-text-field v-model="task_text" :rules="[textRules.required, textRules.max, textRules.date]" :counter="50" label="内容" required></v-text-field>
                            </v-col>
                            <v-col cols="2" sm="1" class="my-2 px-1">
                                <v-btn class="mx-2" fab dark color="cyan" small v-on:click="createTask">
                                    <v-icon dark>mdi-plus</v-icon>
                                </v-btn>
                            </v-col>
                        </v-row>
                        <li v-for="task in TasksData" :key="task.id" v-if="selectedDate===moment(task.selected_date).format('YYYY-MM-DD')">
                            {{ task.text }}
                            <br/>作成日: {{ moment(task.created_at).format("YYYY年MM月DD日 (dddd) a:h:mm") }}
                        </li>
                    </ul>
                </v-card>
            </v-col>
        </v-row>
        <v-row>
            <v-col cols="12" sm="12" class="my-2 px-1">
                <v-card ontlined style="padding-bottom: 10px; position: relative; bottom: 20px;">
                    <div class="title" style="width: 100%; background-color: #AA00FF; padding: 14px; color: white">タスクの検索</div>
                    <ul class="ma-4">
                        <v-row>
                            <v-col cols="10" sm="11" class="my-2 px-1">
                                <v-text-field
                                        v-model="searchText"
                                        label="検索"
                                        :rules="[textRules.required]"
                                        required
                                ></v-text-field>
                            </v-col>
                            <v-col cols="2" sm="1" class="my-2 px-1">
                                <v-btn class="mx-2" fab dark color="purple accent-4" small v-on:click="searchTask">
                                    <v-icon dark>mdi-magnify</v-icon>
                                </v-btn>
                            </v-col>
                        </v-row>
                        <li v-for="searchTask in searchTasks">
                            {{ searchTask.text }}<br/>
                            カレンダー: <a v-on:click="changeSelectedDate(moment(searchTask.selected_date).format('YYYY-MM-DD'))" style="color: #AA00FF">
                            {{ moment(searchTask.selected_date).format('YYYY-MM-DD') }}</a>
                        </li>
                    </ul>
                </v-card>
            </v-col>
        </v-row>
    </div>
</template>

<script>
    import auth from '../auth/auth'
    import axios from 'axios'
    import moment from 'moment'
    moment.locale("ja", {
        weekdays: ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"],
        weekdaysShort: ["日", "月", "火", "水", "木", "金", "土"]
    });
    export default {
        data: function () {
            return {
                TasksSelectedDate: [],
                TasksData: [],
                selectedDate: moment().format('YYYY-MM-DD'),
                task_text: '',
                textRules: {
                    required: value => !!value || 'タスクの内容を入力してください。',
                    max: v => v.length <= 50 || '最大50文字です。',
                    date: v => moment(this.selectedDate).endOf('days') >= moment() || '今日以前の日付は記入不可能です。'
                },
                searchText: '',
                searchTasks: [],
                moment: moment,
            }
        },
        created: function() {
            this.fetchTasks()
        },
        watch: {
            '$route': 'fetchTasks'
        },
        methods: {
            fetchTasks: function(){
                let _this = this
                axios.get('/api/tasks/', {
                    headers: {'Authorization': `Bearer ${localStorage.token}`}
                }).then(response => {
                    for(var i=0; i<response.data.tasks.length; i++){
                        this.TasksData.push(response.data.tasks[i])
                        this.TasksSelectedDate.push(moment(response.data.tasks[i].selected_date).format('YYYY-MM-DD'))
                    }
                }).catch(response => {
                    auth.logout()
                    _this.$router.push('/login')
                    console.log(response)
                })
            },
            createTask: function(){
                if(this.task_text.trim() === ''){
                    return
                }
                if(this.task_text.length > 50){
                    return
                }
                var task_date = moment(this.selectedDate)
                if(task_date.endOf('days') < moment()){
                    return
                }
                let _this = this
                axios.defaults.headers.common["Authorization"] = localStorage.token
                axios.post('/api/tasks/new', {
                    task: {text: this.task_text, selected_date: task_date}
                }).then(response => {
                    console.log(response)
                    this.TasksData.unshift(response.data.new_task)
                    this.TasksSelectedDate.unshift(moment(response.data.new_task.selected_date).format("YYYY-MM-DD"))
                    this.task_text = ''
                }).catch(response => {
                    auth.logout()
                    _this.$router.push('/login')
                    console.log(response)
                })
            },
            searchTask: function () {
                if(this.searchText.length==0){
                    this.searchTasks = []
                    return
                }
                this.searchTasks = []
                this.searchTasks.length = 0
                for(var i=0; i<this.TasksData.length; i++){
                    if(this.TasksData[i].text.indexOf(this.searchText)!==-1){
                        this.searchTasks.push(this.TasksData[i])
                    }
                }
            },
            changeSelectedDate: function(selected_date){
                this.selectedDate = selected_date
            }
        }
    }
</script>
