<template>
  <div id="app">
    <v-app id="inspire">
      <navbar></navbar>
      <v-content style="position: relative; left: 5%; width: 90%;">
        <router-view></router-view>
      </v-content>
    </v-app>
  </div>
</template>

<script>
  import Navbar from './packs/components/header.vue'
  export default {
    components: {
      'navbar': Navbar
    },
    data: function(){
      return {
        searchQuery: '',
        gridColumns: ['name', 'power'],
        gridData: [
          { name: 'Chuck Norris', power: Infinity },
          { name: 'Bruce Lee', power: 9000 },
          { name: 'Jackie Chan', power: 7000 },
          { name: 'Jet Li', power: 8000 }
        ]
      }
    }
  }
</script>

<style scoped>

</style>
