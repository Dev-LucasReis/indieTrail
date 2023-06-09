<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>IndieTrail</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <script src="https://unpkg.com/vue@next"></script>
</head>
<body>
<%@include file="WEB-INF/jspf/header.jspf" %>
<div id="app" class="container-fluid m-2">
    <div v-if="shared.session">
        <div v-if="error" class="alert alert-danger m-2" role="alert">
            {{error}}
        </div>
        <div v-else>
            <h2>
                Game Library
            </h2>
            <div class="row">
                <div class="col-md-4 mb-4" v-for="item in list" :key="item.rowId">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">{{ item.gameTitle }}</h5>
                            <p class="card-text"><strong>Genre:</strong> {{ item.gameGenre }}</p>
                            <p class="card-text"><strong>Platform:</strong> {{ item.gamePlatform }}</p>
                            <p class="card-text"><strong>Developer:</strong> {{ item.gameDeveloper }}</p>
                            <p class="card-text"><strong>Publisher:</strong> {{ item.gamePublisher }}</p>
                            <p class="card-text"><strong>Release Date:</strong> {{ item.releaseDate }}</p>
                            <p class="card-text"><strong>Price:</strong> {{ item.gamePrice.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }) }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    const app = Vue.createApp({
        data() {
            return {
                shared: shared,
                error: null,
                list: [],
            }
        },
        methods: {
            async request(url = "", method, data) {
                try{
                    const response = await fetch(url, {
                        method: method,
                        headers: {"Content-Type": "application/json"},
                        body: JSON.stringify(data)
                    });
                    if(response.status==200){
                        return response.json();
                    }else{
                        this.error = response.statusText;
                    }
                } catch(e){
                    this.error = e;
                    return null;
                }
            },
            async loadList() {
                const data = await this.request("/indieTrail/api/games?history", "GET");
                if(data) {
                    this.list = data.list;
                }
            }
        },
        mounted() {
            this.loadList();
        }
    });
    app.mount('#app');
</script>
<main></main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
<%@include file="WEB-INF/jspf/footer.jspf" %>
</body>
</html>

