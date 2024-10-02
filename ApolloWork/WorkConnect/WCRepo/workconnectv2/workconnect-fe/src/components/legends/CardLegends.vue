<template>
    <div class="q-pb-sm">
        <div :style="{ width: containerWidth }" class="legend-container q-pt-sm q-mt-sm">
            <div class="row q-gutter-x-sm q-ml-auto legends-data">
            <!-- <span class="text text-bold">{{cardTitle}}</span> -->
                <div class="row q-gutter-x-sm">
                    <div class="mini-line"></div>
                    <span class="text">{{labelOne}}</span>
                </div>
                <div class="row q-gutter-x-sm">
                    <div class="mini-line2"></div>
                    <span class="text">{{labelTwo}}</span>
                </div>
                <div class="row q-gutter-x-sm">
                    <div class="mini-line3"></div>
                    <span class="text">{{labelThree}}</span>
                </div>
                <div class="row q-gutter-x-sm">
                    <div class="mini-line4"></div>
                    <span class="text">{{labelFour}}</span>
                </div>
            </div>
        </div>
    </div>
</template>

<!-- <script setup lang="ts"> -->
<script>
export default {
    name: "CardLegends",
    props:{
        // cardTitle: String,
        labelOne: String,
        labelTwo: String,
        labelThree: String,
        labelFour: String,
        containerWidth: {
            type: String,
            default: "550px"
        }
    }
}

// const props = defineProps<{
//     cardTitle: String,
//     labelOne: String,
//     labelTwo: String,
//     labelThree: String,
//     labelFour: String,
// }>();

</script>
<style scoped>
.legend-container{
    background-color: white;
    min-height: 30px;
    /* width: 600px; */
    text-align: center;
}
.mini-line {
  height: 20px;
  width: 20px;
  border-radius: 50%;
  background-color: #40916c;
}
.mini-line2 {
  height: 20px;
  width: 20px;
  border-radius: 50%;
  background-color: #FFBF00;
}
.mini-line3 {
  height: 20px;
  width: 20px;
  border-radius: 50%;
  background-color: #d5a003;
}
.mini-line4 {
  height: 20px;
  width: 20px;
  border-radius: 50%;
  background-color: #AD8100;
}

.second-card-legends .mini-line4 {
  background-color: #ab2e3c;
}

.mindanao-card-legends .mini-line2 {
    background-color: #ab2e3c;
}

.mindanao-card-legends .mini-line4 {
    background-color: white;
}

.mindanao-card-legends .mini-line3 {
    background-color: white;
}

.text{
    font-size: 11px;
}
/* 
@media only screen and (max-width: 600px) {
    .legend-container {
        width: auto;
        height: 100px; 
    }

    .legends-data{
        display: flex;
        flex-direction: column;
    }

    .legends-label{
        
        display: flex;
        flex-direction: row;
        justify-content: space-evenly;
    }

    .text {
        font-size: 9px;
    }
} */
</style>