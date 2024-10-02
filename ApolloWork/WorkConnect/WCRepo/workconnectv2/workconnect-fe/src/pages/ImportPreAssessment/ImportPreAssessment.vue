<template>
  <div class="q-pa-md">
	<q-btn label="Add Import Pre-Assessment (+)" color="primary" @click="createImportpreAssessment()" />

	<q-dialog v-model="formRemarks" persistent transition-show="flip-down">
    <q-card style="width: 450px; max-width: 80vw">
      <q-toolbar>
        <q-toolbar-title
          ><span class="text-weight-bold">Cancellation Remarks</span></q-toolbar-title
        >
        <q-btn flat round dense icon="close" v-close-popup />
      </q-toolbar>

      <q-card-section>
        <q-form @submit="updateApprovalState('CANCELLED', importPreAssessmentDetails)" @reset="onReset" class="q-gutter-sd">
          <div class="q-gutter-md">
     
            <q-input
              filled
              dense
              v-model="importPreAssessmentDetails.cancellationRemarks"
              label="Remarks"
              :rules="[
                (val) =>
                  (val && val.length > 0) || 'Please type your Remarks',
              ]"
            />
          </div>
          <div class="row justify-end">
          
            <q-btn
              :loading="cancelling"
              label="Submit"
              type="submit"
              color="primary"
            >
              <template v-slot:loading>
                <q-spinner-facebook />
              </template>
            </q-btn>
          </div>
        </q-form>
      </q-card-section>
    </q-card>
  </q-dialog>

	<q-dialog v-model="formImport" persistent transition-show="flip-down">
  	<q-card style="width: 550px; max-width: 80vw;">
    	<q-toolbar>
      	<q-toolbar-title
        	><span class="text-weight-bold">Import Pre-Assessment Management</span></q-toolbar-title
      	>
      	<q-btn flat round dense icon="close" v-close-popup />
    	</q-toolbar>
     	<q-card-section>
      	<q-form @submit="createOrEdit(importDetails)" @reset="onReset" class="q-gutter-sd">
          	<!-- <div style="outline: 1px solid rgb(200, 200, 200); border-radius: 5px;"> -->
            	<div style="padding-left: 5px;">
              	<!-- <div  class="q-gutter-md row" style="margin-bottom: 10px;">
                  	<q-label>Please Select Cargo Type:</q-label>
              	</div> -->
            	 
              	<div class="q-gutter-md row" style="align-items: center; width: 500px; margin-bottom: 20px;">
                  	<q-label>Please Select Cargo Type:</q-label>
                  	<q-radio v-model="encodingInput.transactionType" val="Loaded" label="Loaded" />
                  	<q-radio v-model="encodingInput.transactionType" val="Empty" label="Empty" />
                  	<q-radio v-model="encodingInput.transactionType" val="Bulk" label="Bulk" />
              	</div>
          	</div>
            	 
        	<div class="q-gutter-md row">
          	<q-input
            	outlined
            	dense
            	v-model="searchImportInput.blNo"
            	label="Bill Of Lading No/BL No."
            	lazy-rules
            	:rules="[
              	(val) =>
                	(val && val.length > 0) || 'Please type Bill of Lading / BL No',
            	]"
            	style="width: 250px; max-width: 80vw"
          	/>
          	<q-input
            	outlined
            	dense
            	v-model="searchImportInput.entryNo"
            	label="Entry No"
            	:rules="[
              	(val) =>
                	(val && val.length > 0) || 'Please type Entry Number',
            	]"
            	style="width: 250px; max-width: 80vw"
          	/>
          	<q-input
            	outlined
            	dense
            	v-model="searchImportInput.registryNo"
            	label="Registry No"
            	:rules="[
              	(val) =>
                	(val && val.length > 0) || 'Please type Registry Number',
            	]"
            	style="width: 250px; max-width: 80vw"
          	/>
          	<q-input
            	outlined
            	dense
            	v-model="searchImportInput.year"
            	label="Year"
            	style="width: 250px; max-width: 80vw"
          	/>


        	</div>
      	 
        	<div class="row justify-end q-mt-md">
        	<!-- <div class="row justify-center q-mt-md">  -->
          	<q-btn
            	label="Clear"
            	type="reset"
            	color="primary"
            	flat
            	class="q-mr-sm"
          	/>
          	<q-btn :loading="searching" color="primary" class="q-mr-sm" @click="searchEtradeImportPreAssesment()">
              	<template v-slot:loading>
                  	<q-spinner-facebook />
              	</template>
              	<q-icon name="search"/>
              	<span class="q-ml-xs">Search</span>
          	</q-btn>


          	<q-btn color="primary" class="q-mr-sm" @click="createEncoding()">
              	<template v-slot:loading>
                  	<q-spinner-facebook />
              	</template>
              	<q-icon name="edit"/>
              	<span class="q-ml-xs">Encoding Form</span>
          	</q-btn>


          	<!-- <q-btn
            	:loading="submitting"
            	label="Save"
            	type="submit"
            	color="primary"
          	>
            	<template v-slot:loading>
              	<q-spinner-facebook />
            	</template>
          	</q-btn> -->
        	</div>
      	</q-form>
    	</q-card-section>
  	</q-card>
	</q-dialog>





	<!-- ////////////////////////////////////////
	//////////  Encoding Form  ////////////
	/////////////////////////////////////// -->


	<q-dialog v-model="formEncoding" persistent transition-show="flip-down" @hide="onReset">
  	<q-card style="width: 700px; max-width: 80vw;">
    	<q-toolbar>
      	<q-toolbar-title
        	><span class="text-weight-bold" v-if="updateMode" >Update Import Pre-Assessment</span>
			<span class="text-weight-bold" v-else >Create Import Pre-Assessment</span></q-toolbar-title
      	>
      	<q-btn flat round dense icon="close" v-close-popup />
    	</q-toolbar>
     	<q-card-section>
      	<q-form class="q-gutter-sd" @submit="createEncodingPreAssessment()" @reset="onReset" >
          	<div class="col-sm-12 row">
				
            	<div class="col-sm-4">
              	<div class="col-sm-12" style="padding-bottom: 10px; padding-right: 10px;">
                	<q-select
					:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
					:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                  	dense
                  	outlined
                  	v-model="encodingInput.transactionType"
                  	:options="transactionTypeOptions"
                  	option-value="value"
                  	option-label="label"
                  	placeholder="Transaction Type"
                  	label="Transaction Type">
					</q-select>
                	<!-- <p>Selected option: {{ importDetails.transactionType }}</p> -->


              	</div>
            	</div>
            	<div class="col-sm-4">
              	<div class="col-sm-12" style="padding-bottom: 10px;">
                	<q-input
					:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
					:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                	outlined
                	dense
                	v-model="encodingInput.consigneeName"
                	label="Consignee Name"
                	lazy-rules
                	:rules="[
                  	(val) =>
                    	(val && val.length > 0) || 'This field is required.',
                	]"
              	/>
              	</div>
            	</div>


            	<div class="col-sm-4">
              	<div class="col-sm-12" style="padding-bottom: 0px; padding-left: 10px; padding-right: 10px;">
                	<q-input
					:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
					:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                  	outlined
                  	dense
                  	v-model="encodingInput.consigneeTin"
                  	label="Consignee Tin"
                  	lazy-rules
                  	:rules="[
                    	(val) =>
                      	(val && val.length > 0) || 'This field is required.'
                  	]"
                	/>
              	</div>
            	</div>


            	<div class="col-sm-12">
              	<div class="col-sm-12" style="padding: 10px; padding-top: 0px; padding-left: 0px;">
              	<q-input
				  	:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
					:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                	dense
                	v-model="encodingInput.consigneeAddress"
                	label="Consignee Address"
                	lazy-rules
                	:rules="[
                  	(val) =>
                    	(val && val.length > 0) || 'This field is required.',
                	]"
              	/>
            	</div>


            	<div class="col-sm-12 row">
              	<div class="col-sm-6">
                	<div style="padding: 10px; padding-top: 0px; padding-left: 0px;">
                  	<q-input
					  	:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
						:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                    	outlined
                    	dense
                    	v-model="encodingInput.broker"
                    	label="Broker Name"
                    	lazy-rules
                    	:rules="[
                      	(val) =>
                        	(val && val.length > 0) || 'This field is required.',
                    	]"
                  	/>
                	</div>
              	</div>
              	<div class="col-sm-6">
                	<div style="padding: 10px; padding-top: 0px; padding-left: 0px;">
                  	<q-input
					  	:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
						:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                    	outlined
                    	dense
                    	v-model="encodingInput.brokerTin"
                    	label="Broker Tin"
                    	lazy-rules
                    	:rules="[
                      	(val) =>
                        	(val && val.length > 0) || 'This field is required.',
                    	]"
                  	/>
                	</div>
              	</div>
          	</div>


          	<div class="col-sm-12 row">
            	<div class="col-sm-12" style="padding: 10px; padding-top: 0px; padding-left: 0px;">
              	<q-input
				  	:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
					:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                	dense
                	v-model="encodingInput.commodity"
                	label="Comodity"
                	lazy-rules
                	:rules="[
                  	(val) =>
                    	(val && val.length > 0) || 'This field is required.',
                	]"
              	/>
            	</div>
          	</div>
			
			  <div class="col-sm-12 row" style="padding: 10px; padding-top: 0px; padding-left: 0px;" v-if="encodingInput.transactionType?.value == 'Bulk' || encodingInput.transactionType == 'Bulk'" >
				<div class="col-sm-6" style="padding-right: 20px;">
                	<q-input
					:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
					:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                  	dense
                  	
                  	v-model="encodingInput.grossweight"
                  	label="Gross Weight"
                  	:rules="[rules.requiredField, rules.float]"
                	/>
              	</div>
				  <div class="col-sm-6" style="padding-right: 20px;">
                	<q-input
					:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
					:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                  	dense
                  
                  	v-model="encodingInput.cbm"
                  	label="CBM"
					:rules="[rules.requiredField, rules.float]"
                  	lazy-rules
                	/>
              	</div>
          	</div>

			 

          	<div class="col-sm-12 row">
            	<div class="col-sm-4">
              	<div style="padding: 10px; padding-top: 0px; padding-left: 0px;">
                	<q-input
					:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
					:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                  	outlined
                  	dense
                  	v-model="encodingInput.blNo"
                  	label="BL No."
                  	lazy-rules
                  	:rules="[
                    	(val) =>
                      	(val && val.length > 0) || 'This field is required.',
                  	]"
                	/>
              	</div>
            	</div>
            	<div class="col-sm-4">
              	<div style="padding: 10px; padding-top: 0px;">
                	<q-input
					:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
					:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                  	outlined
                  	dense
                  	v-model="encodingInput.entryNo"
                  	label="Entry No."
                  	lazy-rules
                  	:rules="[
                    	(val) =>
                      	(val && val.length > 0) || 'This field is required.',
                  	]"
                	/>
              	</div>
            	</div>
            	<div class="col-sm-4">
              	<div style="padding: 10px; padding-top: 0px;  margin-right: 0px">
                	<q-input
					:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
					:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                  	outlined
                  	dense
                  	v-model="encodingInput.registryNo"
                  	label="Registry No."
                  	lazy-rules
                  	:rules="[
                    	(val) =>
                      	(val && val.length > 0) || 'This field is required.',
                  	]"
                	/>
              	</div>
            	</div>
          	</div>




          	<div class="col-sm-12 row">
            	<div class="col-sm-4">
              	<div style="padding: 10px; padding-top: 0px; padding-left: 0px;">
                	<q-input
					:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
					:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                  	outlined
                  	dense
                  	v-model="encodingInput.vessel"
                  	label="Vessel"
                  	lazy-rules
                  	:rules="[
                    	(val) =>
                      	(val && val.length > 0) || 'This field is required.',
                  	]"
                	/>
              	</div>
            	</div>
            	<div class="col-sm-4">
              	<div style="padding: 10px; padding-top: 0px;">
                	<q-input
					:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
					:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                  	outlined
                  	dense
                  	v-model="encodingInput.voyageNo"
                  	label="Voyage No."
                  	lazy-rules
                  	:rules="[
                    	(val) =>
                      	(val && val.length > 0) || 'This field is required.',
                  	]"
                	/>
              	</div>
            	</div>
            	<div class="col-sm-4">
              	<div style="padding: 10px; padding-top: 0px;  margin-right: 0px">
                	<q-input
                  	outlined
                  	dense
                  	v-model="encodingInput.arrastre"
                  	label="Arrastre Share (20%)"
                  	lazy-rules
                  	:rules="[
                    	(val) =>
                      	(val && val.length > 0) || 'This field is required.',
                  	]"
					@update:model-value="computeEWT()"
                	/>
              	</div>
            	</div>
          	</div>
          	<div class="col-sm-12 row">
            	<div class="col-sm-6 row">
              	<div class="col-sm-12" style="padding-right: 20px;">
                	<q-select
						:readonly="hasPermission('GROUP_CPA_ASSESSOR')"
						:disable="hasPermission('GROUP_CPA_ASSESSOR')"
                  		dense
                  		outlined
                  		v-model="encodingInput.has_EWT"
                  		:options="ewtOptions"
                  		option-value="value"
                  		option-label="label"
                  		placeholder="Withholding Tax (EWT)"
                  		label="Withholding Tax (EWT)"
						map-options
						emit-value
						@update:model-value="computeEWT()"
                  	></q-select>
                	<!-- <p>Selected option: {{ importDetails.transactionType }}</p> -->
              	</div>


              	<div class="col-sm-12" style="padding-right: 20px;">
                	<q-input
					:readonly="hasPermission('GROUP_CPA_ASSESSOR')||(encodingInput.has_EWT == false)"
					:disable="hasPermission('GROUP_CPA_ASSESSOR')||(encodingInput.has_EWT == false)"
                  	dense
                  	:disabled="!encodingInput.withholdingTax"
                  	v-model="encodingInput.withholdingTax"
                  	label="Withholding Tax (EWT) amount"
                  	lazy-rules
                	/>
              	</div>
            	</div>
            	<div class="col-sm-6 row">
              	<div class="col-sm-12" style=" padding-right: 20px;">
					
					<q-input :disable="hasPermission('GROUP_CPA_ASSESSOR')" dense label="" v-model="encodingInput.lastDischargeDate" :readonly="true" :rules="[rules.requiredField]">
                            <template v-slot:label>
                                <div>Last Discharge Date <span class="text-red">*</span></div>
                            </template>
                            <template v-slot:append>
                                <q-icon name="event" class="cursor-pointer">
                                <q-popup-proxy ref="qDateProxy" cover transition-show="scale" transition-hide="scale">
                                    <q-date v-model="encodingInput.lastDischargeDate" mask="YYYY-MM-DD">
                                    <div class="row items-center justify-end">
                                        <q-btn v-close-popup label="Close" color="primary" flat></q-btn>
                                    </div>
                                    </q-date>
                                </q-popup-proxy>
                                </q-icon>
                            </template>
                          </q-input>
                	
              	</div>


              	<div class="col-sm-12" style="padding-right: 20px;">

					<q-input :disable="hasPermission('GROUP_CPA_ASSESSOR')" dense label="" v-model="encodingInput.storageStartDate" :readonly="true" :rules="[rules.requiredField]">
                            <template v-slot:label>
                                <div>Storage Start Date<span class="text-red">*</span></div>
                            </template>
                            <template v-slot:append>
                                <q-icon name="event" class="cursor-pointer">
                                <q-popup-proxy ref="qDateProxy" cover transition-show="scale" transition-hide="scale">
                                    <q-date v-model="encodingInput.storageStartDate" mask="YYYY-MM-DD">
                                    <div class="row items-center justify-end">
                                        <q-btn v-close-popup label="Close" color="primary" flat></q-btn>
                                    </div>
                                    </q-date>
                                </q-popup-proxy>
                                </q-icon>
                            </template>
                          </q-input>
                	
              	</div>
            	</div>
             	 
          	</div>
           	 
        	</div>
      	</div>



    	 
      	 
    	 
        	<div class="row q-mt-md">
        	<!-- <div class="row justify-center q-mt-md">  -->
          	<div class="col-sm-12" style="display: flex; justify-content: right; align-items: center;">
            	<q-btn
              	label="Clear"
              	type="reset"
              	color="primary"
              	flat
              	class="q-mr-sm"
				v-if="!hasPermission('GROUP_CPA_ASSESSOR')"
            	/>


            	<q-btn
            	:loading="searching"
            	label="Save"
            	type="submit"
            	color="primary">
              	<template v-slot:loading>
                	<q-spinner-facebook />
              	</template>
            	</q-btn>
         	 
          	</div>
         	 
        	</div>
      	</q-form>
    	</q-card-section>
  	</q-card>
	</q-dialog>





	<!-- ///////////////////////////////////////
    	//////////  Import Details  ///////////
   	/////////////////////////////////////// -->


	<q-dialog v-model="formImportPreAsessmentDetails" persistent transition-show="flip-down" @hide="loadData">
  	<q-card :loading="loading" style="width: 1500px; max-width: 700vw; height: 600px; max-height: 120vw; position: relative;">
    	<q-dialog v-model="ShowPayments" persistent transition-show="flip-down">
      	<landbank-payment
        	:paymentdetails="paymentdata"
      	/>
    	</q-dialog>
    	<q-toolbar>
      	<q-toolbar-title
        	><span class="text-weight-bold">View Import Pre-Assessment</span></q-toolbar-title>
      	<q-btn flat round dense icon="close" v-close-popup />
    	</q-toolbar>


          	<q-tabs
            	v-model="tab"
            	dense
            	class="bg-grey-2 text-grey-7"
            	active-color="primary"
            	indicator-color="green"
            	align="justify"
          	>


            	<q-tab name="details" label="Details"></q-tab>
            	<q-tab name="summaryComputation" label="Summary Computation || Payment Details || Exemptions"></q-tab>
            	<q-tab name="containerList" :label="importPreAssessmentDetails.transactionType == 'Bulk' ? 'Transaction List':'Container List'"></q-tab>
          	</q-tabs>


          	<div class="q-gutter-sd" style="min-height:475px">
          	<q-tab-panels v-model="tab" animated class="bg-white-5 text-white">
          	 
            	<q-tab-panel name="details">
              	<q-form class="q-gutter-sd">               	 
                	<div class="row">
                  	<div class="col-sm-3 justify-start">

                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Reference Number
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.transactionReferenceNumber }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Transaction Type
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.transactionType }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Consignee Name
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.consigneeName }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Consignee Address
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.consigneeAddress }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Consignee TIN
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.consigneeTin }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Broker Name
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.broker }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Broker TIN
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.brokerTin }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label" style="display: flex; justify-content: left ; align-items: top;">
                            	Commodity
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.commodity }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>
                  	 
                  	</div>
                  	<div class="col-sm-1 justify-end">
                  	 
                  	</div>
                  	<div class="col-sm-3 justify-end">
                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Gross Weight
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.grossweight }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Cubic meter
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.cbm }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	B/L No
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.blNo }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Entry No
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.entryNo }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Registry No
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.registryNo }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>




                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Vessel
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.vessel }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Voyage No
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.voyageNo }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Last Discharge Date
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.lastDischargeDate }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Storage Start Date
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.storageStartDate }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Status
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.status }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Date Created
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.dateCreated }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Created By
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.createdBy }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                  	 


                  	</div>
                  	<div class="col-sm-1">
                  	 
                  	</div>
                  	<div class="col-sm-3">


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Date Applied
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.dateApplied }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Applied By
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.appliedBy }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Date Approved
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.dateApproved }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Approved By
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.approvedBy }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Date Rejected
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.dateRejected }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Rejected By
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.rejectedBy }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Date Tagged As Paid
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.dateTaggedAsPaid }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Tagged As Paid By
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.taggedAsPaidBy }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Date Tagged as Cancelled
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.dateCancelled }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Cancelled By
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.cancelledBy }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Cancellation Remarks
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.cancellationRemarks }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Last Updated Date
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.lastUpdated }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>




                  	</div>
                	</div>
                	<!-- Remaining code... -->
              	</q-form>


            	</q-tab-panel>


            	<q-tab-panel name="summaryComputation">


              	<q-form class="q-gutter-sd">
                	<div class="row">
                  	<div class="col-sm-3">
                    	<q-item-section>
                      	<q-item-label class="text-black outlined-label" style="font-size: 20px; padding-bottom: 10px;">
                        	Summary Computation
                      	</q-item-label>
                    	</q-item-section>
                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Amount
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.amount }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>
                    	 
                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Value Added Tax (12%)
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.vat }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	 
                    	<div class="col-sm-12">
                      	<q-item dense>
                        	<q-item-section>
                          	<q-item-label class="text-black outlined-label">
                            	Withholding Tax (EWT)
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label style="color:rgb(80, 80, 80)">
                            	: {{ importPreAssessmentDetails.withholdingTax }}
                          	</q-item-label>
                        	</q-item-section>
                      	</q-item>
                    	</div>


                    	<div class="col-sm-12">
                        	<q-item dense>
                          	<q-item-section>
                            	<q-item-label class="text-black outlined-label">
                              	Arrastre Share (20%)
                            	</q-item-label>
                          	</q-item-section>
                          	<q-item-section>
                            	<q-item-label style="color:rgb(80, 80, 80)">
                              	: {{ importPreAssessmentDetails.arrastre }}
                            	</q-item-label>
                          	</q-item-section>
                        	</q-item>
                      	</div>


                      	<div class="col-sm-12">
                      	 
                      	</div>


                      	<div class="col-sm-12">
                        	<q-item dense>
                          	<q-item-section>
                            	<q-item-label class="text-black outlined-label">
                              	Total Amount Due (PHP)
                            	</q-item-label>
                          	</q-item-section>
                          	<q-item-section>
                            	<q-item-label style="color:rgb(80, 80, 80)">
                              	: {{ importPreAssessmentDetails.totalAmount }}
                            	</q-item-label>
                          	</q-item-section>
                        	</q-item>
                      	</div>


                      	<q-separator inset></q-separator>
                      	<q-separator inset></q-separator>

                      	<q-item-section>
                        	<q-item-label class="text-black outlined-label" style="font-size: 20px; padding-bottom: 10px; padding-top: 20px;">
                          	Payment Details
                        	</q-item-label>
                      	</q-item-section>


                      	<div class="col-sm-3">
                        	<div class="col-sm-12">
                          	<q-item dense>
                            	<q-item-section>
                              	<q-item-label class="text-black outlined-label">
                                	Mode of Payment
                              	</q-item-label>
                            	</q-item-section>
                            	<q-item-section>
                              	<q-item-label style="color:rgb(80, 80, 80)">
                                	: {{ paymentDetails.paymentType }}
                              	</q-item-label>
                            	</q-item-section>
                          	</q-item>
                        	</div>


                        	<div class="col-sm-12">
                          	<q-item dense>
                            	<q-item-section>
                              	<q-item-label class="text-black outlined-label">
                                	Reference No
                              	</q-item-label>
                            	</q-item-section>
                            	<q-item-section>
                              	<q-item-label style="color:rgb(80, 80, 80)">
                                	: {{ paymentDetails.transactionReferenceNumber }}
                              	</q-item-label>
                            	</q-item-section>
                          	</q-item>
                        	</div>


                        	<div class="col-sm-12">
                          	<q-item dense>
                            	<q-item-section>
                              	<q-item-label class="text-black outlined-label">
                                	O.R
                              	</q-item-label>
                            	</q-item-section>
                            	<q-item-section>
                              	<q-item-label style="color:rgb(80, 80, 80)">
                                	: {{ paymentDetails.orNo}}
                              	</q-item-label>
                            	</q-item-section>
                          	</q-item>
                        	</div>
                      	</div>




                  	</div>


                  	 


                    <div class="col-sm-1 justify-start"></div>

                    	<div class="col-sm-4">
                      		<!-- <div style="padding: 10px; color: black;">
                        		{{ listOfCheckedExemptions }}
                      		</div> -->
                      		<q-item-section>
                        		<q-item-label class="text-black outlined-label" style="font-size: 20px; padding-bottom: 10px;">
                        	  	Exemptions
                        		</q-item-label>
                      		</q-item-section>
                      		<div class="row">
                        		<div v-for="exemption in listOfExemptions" :key="exemption.id" style="padding: 10px; min-width:100px; color: black;">
									<q-checkbox v-model="selectedExemption"
									:disable="isDisabled_input()"
												:val="exemption.code"
												:id="exemption.id"

												:label="exemption.code"
												@update:model-value="exemptionListener(exemption.id)" color="primary" dense style="color: black;" />

												
								</div>
                      		</div>

							<!-- <div class="col-sm-1">
								{{importPreAssessmentDetails.filename}}
								<q-file dense v-model="or_file_1" :label="importPreAssessmentDetails.filename ?? 'Upload OR file'"  />
								<q-btn color="primary" label="Upload" @click="uploadOrImportPreAssessment(or_file_1,'1',importPreAssessmentDetails)"/>
							</div> -->

                    	</div>


						<div class="col-sm-4">
							<q-item-section>
                        		<q-item-label class="text-black outlined-label" style="font-size: 20px; padding-bottom: 10px;">
                        	  	Files
                        		</q-item-label>
                      		</q-item-section>
                      		<div class="col-sm-12">
						
						
								<div v-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')">
							<q-item dense>
                        	<q-item-section style="max-width: 170px !important;" >
                          	<q-item-label class="text-black outlined-label">
                            	Uploaded OPASCOR File1:
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label v-if="importPreAssessmentDetails.filename" style="color:rgb(80, 80, 80)" >
								<q-item class="flex items-center no-wrap">  
									
									<span style="overflow-wrap:anywhere">
									{{ importPreAssessmentDetails.filename }}
								</span>
							<q-btn
							style="margin-right: 5px;"	
								:loading="deletingOr"
								color="red"
								round
								dense
								size="sm"
								icon="remove"
								@click="removeOrFile('1',importPreAssessmentDetails, importPreAssessmentDetails.filename )"
								v-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')"
							/>
							<q-btn
								:loading="deletingOr"
								
								round
								dense
								size="sm"
								icon="download"
								@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '1',importPreAssessmentDetails)"
								v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR')"
							/>
								
								</q-item>
								
                          	</q-item-label>
							  <q-item-label v-else-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')"	>
								<q-item class="flex items-center no-wrap"> 
                        	
								
							<q-file style="width:250px" dense v-model="or_file_1" label='Upload OR file' />
							
					
							<q-btn 
							:loading="uploading"
							color="positive"
								round
								dense
								size="sm"
								icon="upload" @click="uploadOrImportPreAssessment(or_file_1,'1',importPreAssessmentDetails)"
								
								/>
								
						  </q-item>
							  </q-item-label>
							  


                        	</q-item-section>
                      	</q-item>
						 
							
								</div>
								<div v-else-if="importPreAssessmentDetails.filename">
								<q-item dense>
                        	<q-item-section style="max-width: 170px !important;" >
                          	<q-item-label class="text-black outlined-label">
								
                            	Uploaded OPASCOR File1:
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label v-if="importPreAssessmentDetails.filename" style="color:rgb(80, 80, 80)">
								<q-item class="flex items-center no-wrap">  
									<span style="overflow-wrap:anywhere">
										{{ importPreAssessmentDetails.filename }}
								</span>						
							<q-btn
								:loading="deletingOr"
								
								round
								dense
								size="sm"
								icon="download"
								@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '1',importPreAssessmentDetails)"
								v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR')"
							/>
						
						
						</q-item>
                            
                          	</q-item-label>
							 
                        	</q-item-section>
                      	</q-item>
							 </div>

<!-- OPASCOR 1 -->
								

								<div v-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')">
									<q-item dense>
                        	<q-item-section style="max-width: 170px !important;" >
							
                          	<q-item-label class="text-black outlined-label">
                            	Uploaded OPASCOR File2:
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label v-if="importPreAssessmentDetails.filename2" style="color:rgb(80, 80, 80)">
								<q-item class="flex items-center no-wrap">  

									<span style="overflow-wrap:anywhere">
										{{ importPreAssessmentDetails.filename2 }}
								</span>
                            	
								<q-btn
								style="margin-right: 5px;"	
								:loading="deletingOr2"
								color="red"
								round
								dense
								size="sm"
								icon="remove"
								@click="removeOrFile('2',importPreAssessmentDetails, importPreAssessmentDetails.filename2 )"
								v-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')"							/>
							<q-btn
								:loading="deletingOr"
								
								round
								dense
								size="sm"
								icon="download"
								@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '2',importPreAssessmentDetails)"
								v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR')"
							/>					
						
						</q-item>
                            	
								
                          	</q-item-label>
							  <q-item-label v-else-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')"	>
								<q-item dense class="flex items-center no-wrap"> 
                        	
								
							<q-file style="width:250px" dense v-model="or_file_2" label='Upload OR file' />
							
					
							<q-btn 
							:loading="uploading2"
							color="positive"
								round
								dense
								size="sm"
								icon="upload" @click="uploadOrImportPreAssessment(or_file_2,'2',importPreAssessmentDetails)"
								
								/>
						  </q-item>
							  </q-item-label>
							  
							
                        	</q-item-section>
                      	</q-item>
						 
								</div>

								<div v-else-if="importPreAssessmentDetails.filename2">
								<q-item dense>
                        	<q-item-section style="max-width: 170px !important;" >
                          	<q-item-label class="text-black outlined-label">
								
                            	Uploaded OPASCOR File2:
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label v-if="importPreAssessmentDetails.filename2" style="color:rgb(80, 80, 80)">
								<q-item class="flex items-center no-wrap">  
									<span style="overflow-wrap:anywhere">
										{{ importPreAssessmentDetails.filename2 }}
								</span>						
							<q-btn
								:loading="deletingOr"
								
								round
								dense
								size="sm"
								icon="download"
								@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '2',importPreAssessmentDetails)"
								v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR')"
							/>
						
						
						</q-item>
                            
                          	</q-item-label>
							 
                        	</q-item-section>
                      	</q-item>
							 </div>
<!-- OPASCOR 2 -->
								<div v-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')">
								<q-item dense>
                        	<q-item-section style="max-width: 170px !important;" >
                          	<q-item-label class="text-black outlined-label">
                            	Uploaded OPASCOR File3:
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label v-if="importPreAssessmentDetails.filename3" style="color:rgb(80, 80, 80)">
								<q-item class="flex items-center no-wrap">  
									<span style="overflow-wrap:anywhere">
										{{ importPreAssessmentDetails.filename3 }}
								</span>
                            	
								<q-btn
								:loading="deletingOr3"
								color="red"
								round
								dense
								size="sm"
								icon="remove"
								@click="removeOrFile('3',importPreAssessmentDetails,importPreAssessmentDetails.filename3)"
								v-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')"
								style="margin-right: 5px;"							/>								
							<q-btn
								:loading="deletingOr"
								
								round
								dense
								size="sm"
								icon="download"
								@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '3',importPreAssessmentDetails)"
								v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR')"
							/>
						
						</q-item>
                            	
                          	</q-item-label>
							  <q-item-label v-else-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')"	>
								<q-item dense class="flex items-center no-wrap"> 
                        	
								
							<q-file style="width:250px" dense v-model="or_file_3" label='Upload OR file' />
							
					
							<q-btn 
							:loading="uploading3"
							color="positive"
								round
								dense
								size="sm"
								icon="upload" @click="uploadOrImportPreAssessment(or_file_3,'3',importPreAssessmentDetails)"
								
								/>
						  </q-item>
							  </q-item-label>
							  
                        	</q-item-section>
                      	</q-item>
						
							</div>

							<div v-else-if="importPreAssessmentDetails.filename3">
								<q-item dense>
                        	<q-item-section style="max-width: 170px !important;" >
                          	<q-item-label class="text-black outlined-label">
								
                            	Uploaded OPASCOR File3:
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label v-if="importPreAssessmentDetails.filename3" style="color:rgb(80, 80, 80)">
								<q-item class="flex items-center no-wrap">  
									<span style="overflow-wrap:anywhere">
										{{ importPreAssessmentDetails.filename3 }}
								</span>						
							<q-btn
								:loading="deletingOr"
								
								round
								dense
								size="sm"
								icon="download"
								@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '3',importPreAssessmentDetails)"
								v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR')"
							/>
						
						
						</q-item>
                            
                          	</q-item-label>
							 
                        	</q-item-section>
                      	</q-item>
							 </div>
							
<!-- OPSASCOR 3  -->
							<div v-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')">
								<q-item dense>
                        	<q-item-section style="max-width: 170px !important;" >
                          	<q-item-label class="text-black outlined-label">
								
                            	Uploaded OPASCOR File4:
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label v-if="importPreAssessmentDetails.filename4" style="color:rgb(80, 80, 80)">
								<q-item class="flex items-center no-wrap">  
									<span style="overflow-wrap:anywhere">
										{{ importPreAssessmentDetails.filename4 }}
								</span>
                            	
								<q-btn
								:loading="deletingOr4"
								color="red"
								round
								dense
								size="sm"
								icon="remove"
								style="margin-right: 5px;"	
								@click="removeOrFile('4',importPreAssessmentDetails)"
								v-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')"							/>								
							<q-btn
								:loading="deletingOr"
								
								round
								dense
								size="sm"
								icon="download"
								@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '4',importPreAssessmentDetails)"
								v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR')"
							/>
						
						
						</q-item>
                            
                          	</q-item-label>
							  <q-item-label v-else-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')"	>
								<q-item dense class="flex items-center no-wrap"> 
                        	
								
							<q-file style="width:250px" dense v-model="or_file_4" label='Upload OR file' />
							
					
							<q-btn 
							:loading="uploading4"
							color="positive"
								round
								dense
								size="sm"
								icon="upload" @click="uploadOrImportPreAssessment(or_file_4,'4',importPreAssessmentDetails,importPreAssessmentDetails.filename4)"
								
								/>
						  </q-item>
							  </q-item-label>
							  
                        	</q-item-section>
                      	</q-item>
						 
							</div>
							 <div v-else-if="importPreAssessmentDetails.filename4">
								<q-item dense>
                        	<q-item-section style="max-width: 170px !important;" >
                          	<q-item-label class="text-black outlined-label">
								
                            	Uploaded OPASCOR File4:
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label v-if="importPreAssessmentDetails.filename4" style="color:rgb(80, 80, 80)">
								<q-item class="flex items-center no-wrap">  
									<span style="overflow-wrap:anywhere">
										{{ importPreAssessmentDetails.filename4 }}
								</span>						
							<q-btn
								:loading="deletingOr"
								
								round
								dense
								size="sm"
								icon="download"
								@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '4',importPreAssessmentDetails)"
								v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR')"
							/>
						
						
						</q-item>
                            
                          	</q-item-label>
							 
                        	</q-item-section>
                      	</q-item>
							 </div>



<!-- OPSACOR4 -->
							

							<div v-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')">
								<q-item dense>
                        	<q-item-section style="max-width: 170px !important;" >
                          	<q-item-label class="text-black outlined-label">
                            	Uploaded OPASCOR File5:
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label v-if="importPreAssessmentDetails.filename5" style="color:rgb(80, 80, 80)">
								<q-item  class="flex items-center no-wrap">  
									<span style="overflow-wrap:anywhere">
									{{ importPreAssessmentDetails.filename5 }}
								</span>
                            	
								<q-btn
								style="margin-right: 5px;"	
								:loading="deletingOr5"
								color="red"
								round
								dense
								size="sm"
								icon="remove"
								
								@click="removeOrFile('5',importPreAssessmentDetails,importPreAssessmentDetails.filename5)"
								v-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')"							/>

							<q-btn
								:loading="deletingOr"
								
								round
								dense
								size="sm"
								icon="download"
								@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '5',importPreAssessmentDetails)"
								v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR')"
							/>
								</q-item >
                            	
                          	</q-item-label>
							  
							  <q-item-label v-else-if="hasPermission('ROLE_GOFAST_UPLOAD_OR') && (importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE')"	>
								<q-item  dense class="flex items-center no-wrap"> 
                        	
								
							<q-file style="width:250px" dense v-model="or_file_5" label='Upload OR file' />
							
								
							<q-btn 
							:loading="uploading5"
							color="positive"
								round
								dense
								size="sm"
								icon="upload" @click="uploadOrImportPreAssessment(or_file_5,'5',importPreAssessmentDetails)"
							
								/>
						  </q-item>
							  </q-item-label>
							  
                        	</q-item-section>
                      	</q-item>
						 
							</div>
							<div v-else-if="importPreAssessmentDetails.filename5">
								<q-item dense>
                        	<q-item-section style="max-width: 170px !important;" >
                          	<q-item-label class="text-black outlined-label">
								
                            	Uploaded OPASCOR File5:
                          	</q-item-label>
                        	</q-item-section>
                        	<q-item-section>
                          	<q-item-label v-if="importPreAssessmentDetails.filename5" style="color:rgb(80, 80, 80)">
								<q-item class="flex items-center no-wrap">  
									<span style="overflow-wrap:anywhere">
										{{ importPreAssessmentDetails.filename5 }}
								</span>						
							<q-btn
								:loading="deletingOr"
								
								round
								dense
								size="sm"
								icon="download"
								@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '5',importPreAssessmentDetails)"
								v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR')"
							/>
						
						
						</q-item>
                            
                          	</q-item-label>
							 
                        	</q-item-section>
                      	</q-item>
							 </div>

							
<!-- OPSACOR5 -->
                    	</div>

                    	</div>
						
                	</div>
					
					
              	</q-form>
            	</q-tab-panel>


          	 
            	<q-tab-panel name="containerList">
                  <q-btn label="Add Container" color="primary" v-if="((importPreAssessmentDetails.status == 'COMPLETE' || importPreAssessmentDetails.status == 'INCOMPLETE') && importPreAssessmentDetails.transactionType != 'Bulk')" @click="OncreateContainer()" />
                  
                  <!-- Importmanagement add container  -->
                  <q-dialog v-model="formContainer" persistent transition-show="flip-down">
                    <q-card style="width: 550px; max-width: 80vw;">
                      <q-toolbar>
                        <q-toolbar-title>
                          <span v-if="is_container_creation" class="text-weight-bold">Create Import Container</span>
                          <span v-else class="text-weight-bold">Update Import Container</span>
                        </q-toolbar-title>
                        <q-btn flat round dense icon="close" v-close-popup />
                      </q-toolbar>
              
                      <q-card-section>
                        <q-form @submit="createOrEdit(importDetails)" @reset="onReset" class="q-gutter-sd">    
                          <div class="q-gutter-md row">
                            <q-input
                              v-if="importPreAssessmentDetails.transactionType == 'Bulk'"
                              filled
                              dense
                              v-model="container_form_data.containerNumber"
                              label="Transaction Type*"
                              required
                              :rules="[rules.requiredField]"
                              style="width: 250px; max-width: 80vw"
                            />
                            <q-input
                              v-else
                              filled
                              dense
                              v-model="container_form_data.containerNumber"
                              label="Container No.*"
                              required
                              :rules="[rules.requiredField]"
                              style="width: 250px; max-width: 80vw"
                            />
                            <q-select
                              v-if="importPreAssessmentDetails.transactionType != 'Bulk'" 
                              dense
                              v-model="container_form_data.size" 
                              :options="['20','40','45']" 
                              label="Size*" 
                              required
                              :rules="[rules.requiredField]"
                              style="width: 250px; max-width: 80vw"
							  @update:model-value="autoInputContainerForm()"
                            />
                            <q-input
                              filled
                              dense
                              v-model="container_form_data.wharfage"
                              label="Wharfage*"
                              required
                              :rules="[rules.requiredField,rules.currency]"
                              style="width: 250px; max-width: 80vw"
                            />
                            <q-input
                              filled
                              dense
                              v-model="container_form_data.bulk"
                              label="Bulk*"
                              required 
                              :rules="[rules.requiredField,rules.currency]"
                              style="width: 250px; max-width: 80vw"
                            />
                            <q-input
                              filled
                              dense
                              v-model="container_form_data.storage"
                              label="Storage*"
                              required 
                              :rules="[rules.requiredField,rules.currency]"
                              style="width: 250px; max-width: 80vw"
                            />
                            <q-input
                              filled
                              dense
                              v-model="container_form_data.penalty"
                              label="Penalty*"
                              required 
                              :rules="[rules.requiredField,rules.currency]"
                              style="width: 250px; max-width: 80vw"
                            />
                            <q-input
                              filled
                              dense
                              v-model="container_form_data.dg"
                              label="DG*"
                              required 
                              :rules="[rules.requiredField,rules.currency]"
                              style="width: 250px; max-width: 80vw"
                            />
                            <q-input
                              filled
                              dense
                              v-model="container_form_data.oc"
                              label="OC*"
                              required 
                              :rules="[rules.requiredField,rules.currency]"
                              style="width: 250px; max-width: 80vw"
                            />
                            <q-input dense label="" v-model="container_form_data.dateStorageValidUntil" class="q-pa-none" required :rules="[rules.requiredField]">
                              <template v-slot:label>
                                  <div>Storage Valid Until*</div>
                              </template>
                              <template v-slot:append>
                                  <q-icon name="event" class="cursor-pointer">
                                  <q-popup-proxy ref="qDateProxy" cover transition-show="scale" transition-hide="scale">
                                      <q-date v-model="container_form_data.dateStorageValidUntil" mask="YYYY-MM-DD" @update:model-value="autoInputContainerForm()">
                                      <div class="row items-center justify-end">
                                          <q-btn v-close-popup label="Close" color="primary" flat></q-btn>
                                      </div>
                                      </q-date>
                                  </q-popup-proxy>
                                  </q-icon>
                              </template>
                            </q-input>
                          </div>
                          <br/>
                          <div class="row justify-end q-mt-md">
                          <!-- <div class="row justify-center q-mt-md">  -->
                            <q-btn
                              label="Clear"
                              type="reset"
                              color="primary"
                              flat
                              class="q-mr-sm"
                              @click="clearContainerForm()"
                            />
                            <q-btn :loading="searching" color="primary" class="q-mr-sm" v-if="is_container_creation" @click="createContainer(container_form_data)">
                                <template v-slot:loading>
                                    <q-spinner-facebook />
                                </template>
                                <q-icon name="save"/>
                                <span class="q-ml-xs">Create</span>
                            </q-btn>
                            <q-btn :loading="searching" color="primary" class="q-mr-sm" v-else @click="updateContainer(container_form_data)">
                                <template v-slot:loading>
                                    <q-spinner-facebook />
                                </template>
                                <q-icon name="edit"/>
                                <span class="q-ml-xs">Update</span>
                            </q-btn>
                          </div>
                        </q-form>
                      </q-card-section>
                    </q-card>
                  </q-dialog>
                  <q-dialog v-model="notification" persistent transition-show="flip-down">
                    <q-card>
                      <q-card-section class="row items-center">
                        <span class="q-ml-sm">{{loading_message}}</span>
                      </q-card-section>
                      <q-card-actions align="right">
                        <q-btn flat label="ok" color="primary" v-close-popup v-if="get_value_from_dialog" @click="update_dialog_value('ok')"/>
                        <q-btn flat label="close" color="primary" v-close-popup />
                      </q-card-actions>
                    </q-card>
                  </q-dialog>


                  <q-table
                    :title="importPreAssessmentDetails.transactionType == 'Bulk' ? 'Transaction List' : 'Containers List'"
                    class="my-sticky-column-table"
                    :rows="importContainersDetails"
                    :columns="importPreAssessmentDetails.transactionType == 'Bulk' ? columnsContainersBulk : columnsContainers"
                    row-key="id"
                    dense
                    :separator="separator"
                    :filter="filter"
                    :loading="loading"
                    :pagination="{ rowsPerPage: 15 }"
                    :rows-per-page-options="[10, 15, 50]"
                  >




                    <template v-slot:top-right="props">
                      <q-input
                        outlined
                        dense
                        debounce="300"
                        v-model="filter"
                        placeholder="Search here..."
                      >
                        <template v-slot:append>
                          <q-icon name="search" />
                        </template>
                      </q-input>
             
                      <q-btn
                        flat
                        round
                        dense
                        :icon="props.inFullscreen ? 'fullscreen_exit' : 'fullscreen'"
                        @click="props.toggleFullscreen"
                      >
                        <q-tooltip :disable="$q.platform.is.mobile" v-close-popup
                          >{{ props.inFullscreen ? "Exit Fullscreen" : "Toggle Fullscreen" }}
                        </q-tooltip>
                      </q-btn>
             
                      <q-btn
                        flat
                        round
                        dense
                        :icon="mode === 'grid' ? 'list' : 'grid_on'"
                        @click="mode = mode === 'grid' ? 'list' : 'grid';
                          separator = mode === 'grid' ? 'vertical' : 'horizontal';"
                        v-if="!props.inFullscreen">
                        <q-tooltip :disable="$q.platform.is.mobile" v-close-popup
                          >{{ mode === "grid" ? "Vertical" : "Grid" }}
                        </q-tooltip>
                      </q-btn>
             
                      <q-btn
                        color="primary"
                        icon-right="archive"
                        no-caps
                        @click="exportTableContainer"
                      />
                    </template>

                    <template v-slot:body-cell-actions="props">
                      <q-td :props="props">
                        <q-btn
                          v-if="((
							hasPermission('ROLE_CLIENT_BROKER') || 
          					hasPermission('ROLE_CLIENT_CFS') || 
          					hasPermission('ROLE_CLIENT_FORWARDER') || 
          					hasPermission('ROLE_CLIENT_IMPORTER_EXPORTER')||
							hasPermission('GROUP_CLIENT_SHIPPING_LINE')
							)&&(
							importPreAssessmentDetails.status === 'COMPLETE' || 
							importPreAssessmentDetails.status === 'INCOMPLETE'
							))||
							(hasPermission('GROUP_CPA_ASSESSOR') && 
							((importPreAssessmentDetails.status === 'ASSESSED')||(importPreAssessmentDetails.status === 'FOR ASSESSMENT')))"
                          class="q-mr-xs"
                          round
                          dense
                          color="positive"
                          size="sm"
                          icon="edit"
                          @click="OnupdateContainer(props)"
                        />
                        <q-btn
                          class="q-mr-xs"
                          round
                          dense
                          color="red"
                          size="sm"
                          icon="delete"
						
                          @click="deleteContainer(props)"
                          :disabled="importPreAssessmentDetails.status === 'COMPLETE' || importPreAssessmentDetails.status === 'INCOMPLETE' ? false : true"
                        />
                      </q-td>
                    </template>
             
                    <template v-slot:loading>
                      <q-inner-loading showing color="primary" />
                    </template>
                  </q-table>
                </q-tab-panel>
          	</q-tab-panels>
        	</div>
          	<div style=" position: sticky; bottom: 15px; width: 100%;">
            	<div class="row justify-end" style="display: flex; justify-content: center ; align-items: center; padding-right: 10px;">
              	<q-btn color="red" class="q-mr-sm" @click.stop="deleteApplication(importPreAssessmentDetails)" v-if="(importPreAssessmentDetails?.status === 'COMPLETE' || importPreAssessmentDetails?.status === 'INCOMPLETE') && user_is_client">
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="delete"/>
                	<span class="q-ml-xs">DELETE APPLICATION</span>
              	</q-btn>


              	<q-btn style="color: darkblue; background: white;" class="q-mr-sm" 
                  v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR') && 
                  importPreAssessmentDetails.filename != null && 
                  importPreAssessmentDetails.status != 'COMPLETE' &&
                  importPreAssessmentDetails.status != 'INCOMPLETE'
                  "
                  @click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '1',importPreAssessmentDetails)"
                  >
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">VIEW OPASCOR OR1</span>
              	</q-btn>
             	 
             	 
              	<q-btn style="color: darkblue; background: white;" class="q-mr-sm"
              	v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR') &&
              	importPreAssessmentDetails.filename2 != null &&
              	importPreAssessmentDetails.status != 'COMPLETE' &&
              	importPreAssessmentDetails.status != 'INCOMPLETE'
              	"
              	@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '2',importPreAssessmentDetails)"
              	>
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">VIEW OPASCOR OR2</span>
              	</q-btn>

              	<q-btn style="color: darkblue; background: white;" class="q-mr-sm"
              	v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR') &&
              	importPreAssessmentDetails.filename3 != null &&
              	importPreAssessmentDetails.status != 'COMPLETE' &&
              	importPreAssessmentDetails.status != 'INCOMPLETE'
              	"
              	@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '3',importPreAssessmentDetails)"
              	>
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">VIEW OPASCOR OR3</span>
              	</q-btn>

              	<q-btn style="color: darkblue; background: white;" class="q-mr-sm"
              	v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR') &&
              	importPreAssessmentDetails.filename4 != null &&
              	importPreAssessmentDetails.status != 'COMPLETE' &&
              	importPreAssessmentDetails.status != 'INCOMPLETE'
              	"
              	@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '4',importPreAssessmentDetails)"
              	>
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">VIEW OPASCOR OR4</span>
              	</q-btn>

              	<q-btn style="color: darkblue; background: white;" class="q-mr-sm"
              	v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR') &&
              	importPreAssessmentDetails.filename5 != null &&
              	importPreAssessmentDetails.status != 'COMPLETE' &&
              	importPreAssessmentDetails.status != 'INCOMPLETE'
              	"
              	@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '5',importPreAssessmentDetails)"
              	>
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">VIEW OPASCOR OR5</span>
              	</q-btn>


              	<!-- <q-btn style="color: darkblue;" class="q-mr-sm"
              	v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR') &&
              	importPreAssessmentDetails.filename2 != null &&
              	importPreAssessmentDetails.status != 'COMPLETE' &&
              	importPreAssessmentDetails.status != 'INCOMPLETE'
              	"
              	@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '2',importPreAssessmentDetails)"
              	>
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">VIEW OPASCOR OR2</span>
              	</q-btn>

              	<q-btn style="color: darkblue;" class="q-mr-sm"
              	v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR') &&
              	importPreAssessmentDetails.filename3 != null &&
              	importPreAssessmentDetails.status != 'COMPLETE' &&
              	importPreAssessmentDetails.status != 'INCOMPLETE'
              	"
              	@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '3',importPreAssessmentDetails)"
              	>
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">VIEW OPASCOR OR3</span>
              	</q-btn>

              	<q-btn style="color: darkblue;" class="q-mr-sm"
              	v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR') &&
              	importPreAssessmentDetails.filename4 != null &&
              	importPreAssessmentDetails.status != 'COMPLETE' &&
              	importPreAssessmentDetails.status != 'INCOMPLETE'
              	"
              	@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '4',importPreAssessmentDetails)"
              	>
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">VIEW OPASCOR OR4</span>
              	</q-btn>

              	<q-btn style="color: darkblue;" class="q-mr-sm"
              	v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_OR') &&
              	importPreAssessmentDetails.filename5 != null &&
              	importPreAssessmentDetails.status != 'COMPLETE' &&
              	importPreAssessmentDetails.status != 'INCOMPLETE'
              	"
              	@click.stop="downloadOrImportPreAssessment('DOWNLOAD_OR', '5',importPreAssessmentDetails)"
              	>
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">VIEW OPASCOR OR5</span>
              	</q-btn> -->


              	<q-btn @click="cancelFormOpen" style="color: red; background: white;" class="q-mr-sm" v-if="(importPreAssessmentDetails.status === 'PAID' || importPreAssessmentDetails.status === 'ASSESSED') && user_is_client">
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">CANCEL APPLICATION</span>
              	</q-btn>


              	<q-btn color="primary" :loading="stateUpdate" class="q-mr-sm" @click.stop="updateApplicationState('APPLY', importPreAssessmentDetails)" v-if="hasPermission('ROLE_GOFAST_APPLY_IMPORT_PRE_ASSESSMENT') && (importPreAssessmentDetails.status === 'COMPLETE')">
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">APPLY</span>
              	</q-btn>


              	<q-btn color="primary" :loading="stateUpdate" class="q-mr-sm" @click.stop="updateApprovalState('APPROVED', importPreAssessmentDetails)" v-if="hasPermission('ROLE_GOFAST_APPROVE_IMPORT_PRE_ASSESSMENT') && (importPreAssessmentDetails.status === 'FOR ASSESSMENT')">
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">APPROVE</span>
              	</q-btn>


              	<q-btn color="red" :loading="stateUpdate" class="q-mr-sm" @click.stop="updateApprovalState('REJECTED', importPreAssessmentDetails)" v-if="hasPermission('ROLE_GOFAST_REJECT_IMPORT_PRE_ASSESSMENT') && (importPreAssessmentDetails.status === 'FOR ASSESSMENT')">
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">REJECT</span>
              	</q-btn>


              	<q-btn color="primary" class="q-mr-sm" @click.stop="gotoPayments('PAID', importPreAssessmentDetails)" v-if="hasPermission('ROLE_GOFAST_PAID_IMPORT_PRE_ASSESSMENT') && (importPreAssessmentDetails.status === 'ASSESSED')">
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">PROCEED TO PAYMENT</span>
              	</q-btn>


              	<q-btn style="color: darkblue; background: white;" class="q-mr-sm" @click.stop="downloadFcwpImportPreAssessment(importPreAssessmentDetails)" v-if="hasPermission('ROLE_GOFAST_DOWNLOAD_FCWP') && (importPreAssessmentDetails.status === 'ASSESSED' || importPreAssessmentDetails.status === 'PAID')">
                	<template v-slot:loading>
                    	<q-spinner-facebook />
                	</template>
                	<q-icon name="download"/>
                	<span class="q-ml-xs">DOWNLOAD FCWP</span>
              	</q-btn>
          	</div>
        	</div>


  	</q-card>
	</q-dialog>
 	<q-table
  	title="Import Pre-Assessment Management"
  	class="my-sticky-column-table"
  	:rows="tablerows"
  	:columns="columnsImport"
  	row-key="id"
   	dense
  	:separator="separator"
  	:filter="filter_import"
  	:loading="loading"
  	:pagination="{ rowsPerPage: 15, sortBy: 'lastUpdated', descending: true }"
  	:rows-per-page-options="[10, 15, 50]"
	>
   	<template v-slot:body-cell-status="props">
    	<q-td key="status" :props="props">
      	    <div class="cell-content" style="display: flex; justify-content: center; align-items: center;">
              	<q-badge :color="props.row.status === 'COMPLETE' || props.row.status === 'PAID' || props.row.status === 'ASSESSED' ? 'green' : (props.row.status === 'FOR ASSESSMENT' ? 'blue' : 'red')">
              		{{ props.row.status }}
            	</q-badge>
      	    </div>
    	</q-td>
  	</template>
   	<template v-slot:body-cell-actions="props">
    	<q-td :props="props" class="text-left" >
      		<q-btn
        		round
        		dense
        		size="sm"
        		icon="zoom_in"
        		@click="viewImport(props.row.id)"
      		/>

			  <q-btn
			  	color="primary"
        		round
        		dense
        		size="sm"
        		icon="edit"
        		@click="editImport(props)"
				v-if="(hasPermission('ROLE_GOFAST_UPDATE_IMPORT_PRE_ASSESSMENT') && isEditable(props))||
				(hasPermission('GROUP_CPA_ASSESSOR') && ((props.row.status === 'ASSESSED')||(props.row.status === 'FOR ASSESSMENT')))"
      		/>
    	</q-td>
  	</template>
   	<template v-slot:top-right="props">
    	<!-- <div class="boxed-input" v-if="fromDashboard && selectedChips.length > 0">
          <div class="chips-container">
            <template v-for="(chip, index) in selectedChips" :key="index">
              <q-chip dense outlined removable @remove="removeChip(chip)">
                {{ chip }}
              </q-chip>
            </template>
          </div>

          <q-input
            outlined
            dense
            debounce="300"
            v-model="filter_import"
            placeholder="Search here..."
            
            @keydown.enter="addChip"
            v-if="selectedChips.length == 0"
          >
            <template v-slot:append>
              <q-icon name="search" @click="addChip" class="cursor-pointer" />
            </template>
          </q-input>
        </div> -->
        <q-input
          outlined
          dense
          debounce="300"
          v-model="filter_import"
          placeholder="Search here..."
          clearable
          
        >
          <template v-slot:append>
            <q-icon name="search" />
          </template>
        </q-input>
     	<q-btn
      	flat
      	round
      	dense
      	:icon="props.inFullscreen ? 'fullscreen_exit' : 'fullscreen'"
      	@click="props.toggleFullscreen"
    	>
      		<q-tooltip :disable="$q.platform.is.mobile" v-close-popup
        		>{{ props.inFullscreen ? "Exit Fullscreen" : "Toggle Fullscreen" }}
      		</q-tooltip>
    	</q-btn>
     	<q-btn
      	flat
      	round
      	dense
      	:icon="mode === 'grid' ? 'list' : 'grid_on'"
      	@click="
        	mode = mode === 'grid' ? 'list' : 'grid';
        	separator = mode === 'grid' ? 'vertical' : 'horizontal';
      	"
      	v-if="!props.inFullscreen"
    	>
      		<q-tooltip :disable="$q.platform.is.mobile" v-close-popup
        		>{{ mode === "grid" ? "Vertical" : "Grid" }}
      		</q-tooltip>
    	</q-btn>
     	<q-btn
      	color="primary"
      	icon-right="archive"
      	no-caps
      	@click="exportTable"
    	/>
  	</template>
   	<template v-slot:loading>
    	<q-inner-loading showing color="primary" />
  	</template>
	</q-table>
  </div>
  <!-- <div class="q-pa-md">Selected: {{ JSON.stringify(selected) }}</div> -->
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue';
import { exportFile, useQuasar, Dialog } from "quasar";
import api from "src/api/API";
import {auth} from 'stores/auth'
import { storeToRefs } from 'pinia';
import LandbankPayment from "src/pages/ImportPreAssessment/LandbankPayment.vue"
import { useRoute } from 'vue-router';
// import EncodingForm from "src/components/ImportPreAssessment/EncodingForm.vue";
const cancelling = ref(false);
const formRemarks = ref(false);
const searching = ref(false);
const $q = useQuasar();
const mode = ref(null);
const addTransaction = ref(true);
const ShowPayments = ref(false);
const submitting = ref(false);
const separator = ref("vertical");
const rows = [];
const tablerows = ref([]);
const loading = ref(false);
const filter = ref("");
const filter_import = ref("");

const formImport = ref(false);
const formImportPreAsessmentDetails = ref(false);
const formContainer = ref(false);
const formEncoding = ref(false);
const titleForm = ref("");
const cargoType = ref("");
const tab = ref('');
const importPreAssessmentDetails =ref([])
const importContainersDetails =ref([])
const stateUpdate = ref(false);
const is_container_creation = ref(false)
const uploading = ref(false);
const uploading2 = ref(false);
const uploading3 = ref(false);
const uploading4 = ref(false);
const uploading5 = ref(false);
const deletingOr = ref(false);
const deletingOr2 = ref(false);
const deletingOr3 = ref(false);
const deletingOr4 = ref(false);
const deletingOr5 = ref(false);
const checked = ref(false);
const listOfExemptions= ref([]);
const etradeImportData = ref([])
const updateMode = ref(false);
const or_file_1 = ref(null)
const or_file_2 = ref(null)
const or_file_3 = ref(null)
const or_file_4 = ref(null)
const or_file_5 = ref(null)
const selectedExemption = ref([]);
const clientUser = ref({});
const selectedChips = ref([]);
const importDetails = ref({
  id: null,
  transactionType: null,
  agencyTypes: null,
  code: null,
  createdBy: null,
  dateCreated: null,
  description: null,
  exemptions: null,
  lastUpdated: null,
  lastUpdatedBy: null,
});

const container_form_data = ref({
  importPreAssessmentId: null,
  containerId: null,
  containerNumber: null,
  size: null,
  wharfage: null,
  bulk: null,
  storage: null,
  dg: null,
  oc: null,
  penalty: null,
  dateStorageValidUntil: null
})

const paymentdata = ref({
  accountNumbers:'',
  mobile:'',
  amount:'',
  accountName:'',
  email:'',
  transactionType:'',
  chargeReferenceNumber:'',
})
const paymentDetails = ref({
  transactionReferenceNumber: null,
  paymentType: null,
  orNo: null,
});

const searchImportInput = ref({
  blNo: null,
  entryNo: null,
  registryNo: null,
  year: null,
})


const encodingInput  = ref({
  transactionType: null,
  consigneeName: null,
  consigneeTin: null,
  consigneeAddress: null,
  brokerTin: null,
  brokerName: null,
  commodity: null,
  blNo: null,
  entryNo: null,
  registryNo: null,
  vessel: null,
  voyageNo: null,
  arrastre: null,
  ewt: null,
  ewtAmount: null,
  lastDischargeDate: null,
  storageStartDate: null,
  containers: [],
})

const queryCreatedImportPreAssesment = ref({
        dateFrom: "",
        dateTo: "",
        transRefNo: "",
        consigneeName: "",
        blNo: "",
        entryNo: "",
        status:"",
})


const listOfCheckedExemptions = ref([]);

onMounted(() => {
  getUserDetails();  
	listOfCheckedExemptions.value = Array(listOfExemptions.length).fill(false);
});

 const columnsImport = [
  {
   
	label: "Reference No",
	align: "left",
	field: (row) => row.transactionReferenceNumber,
	name: "transactionReferenceNumber",
	sortable: true,
  },
  {
	align: "left",
	label: "BL No",
	field: (row) => row.blNo,
	name: "blNo",
	sortable: true,
  },
  {
	align: "left",
	label: "Consignee Name",
	field: (row) => row.consigneeName,
	name: "consigneeName",
	sortable: true,
  },
  {
	align: "left",
	label: "Entry No",
	field: (row) => row.entryNo,
	name: "entryNo",
	sortable: true,
  },
  {
	align: "left",
	label: "Total Amount",
	field: (row) => row.totalAmount,
	name: "totalAmount",
	sortable: true,
  },
  {
	align: "center",
	label: "Date Created",
	field: (row) => row.dateCreated,
	name: "dateCreated",
	sortable: true,
  },
  {
	align: "center",
	label: "Date Last Updated",
	field: (row) => row.lastUpdated,
	name: "lastUpdated",
	sortable: true,
  },
  {
	align: "center",
	label: "Status",
	field: (row) => row.status,
	name: "status",
	sortable: true,
  },
  { name: "actions", label: "Action", align: "center", style: "width:0px;" },
];


const columnsContainers = [
  {
   
	label: "Container No",
	align: "left",
	field: (row) => row.containerNumber,
	name: "containerNumber",
	sortable: true,
  },
  {
	align: "left",
	label: "Size",
	field: (row) => row.size,
	name: "size",
	sortable: true,
  },
  {
	align: "left",
	label: "Wharfage",
	field: (row) => row.wharfage,
	name: "wharfage",
	sortable: true,
  },
  {
	align: "left",
	label: "Bulk",
	field: (row) => row.bulk,
	name: "bulk",
	sortable: true,
  },
  {
	align: "left",
	label: "Storage",
	field: (row) => row.storage,
	name: "storage",
	sortable: true,
  },
  {
	align: "center",
	label: "Storage Valid Until",
	field: (row) => row.dateStorageValidUntil,
	name: "datestorageValidUntil",
	sortable: true,
  },
  {
	align: "center",
	label: "Storage Penalty",
	field: (row) => row.penalty,
	name: "penalty",
	sortable: true,
  },
  {
	align: "center",
	label: "OC",
	field: (row) => row.oc,
	name: "oc",
	sortable: true,
  },
  {
	align: "center",
	label: "Total",
	field: (row) => row.totalAmount,
	name: "totalAmount",
	sortable: true,
  },
  { name: "actions", label: "Action", align: "center", style: "width:0px;" },
];

const columnsContainersBulk = [
  {
   
	label: "Transaction Type",
	align: "left",
	field: (row) => 'Bulk',
	name: "transactionType",
	sortable: true,
  },

  {
	align: "left",
	label: "Wharfage",
	field: (row) => row.wharfage,
	name: "wharfage",
	sortable: true,
  },
  {
	align: "left",
	label: "Bulk",
	field: (row) => row.bulk,
	name: "bulk",
	sortable: true,
  },
  {
	align: "left",
	label: "Storage",
	field: (row) => row.storage,
	name: "storage",
	sortable: true,
  },
  {
	align: "center",
	label: "Storage Valid Until",
	field: (row) => row.dateStorageValidUntil,
	name: "datestorageValidUntil",
	sortable: true,
  },
  {
	align: "center",
	label: "Storage Penalty",
	field: (row) => row.penalty,
	name: "penalty",
	sortable: true,
  },
  {
	align: "center",
	label: "OC",
	field: (row) => row.oc,
	name: "oc",
	sortable: true,
  },
  {
	align: "center",
	label: "Total",
	field: (row) => row.totalAmount,
	name: "totalAmount",
	sortable: true,
  },
  { name: "actions", label: "Action", align: "center", style: "width:0px;" },
];


const transactionTypeOptions = [
  { value: 'Loaded', label: 'Loaded' },
  { value: 'Empty', label: 'Empty' },
  { value: 'Bulk', label: 'Bulk' },
];

const ewtOptions = [
  { value: true, label: 'YES' },
  { value: false, label: 'NO' },
];

const getUserDetails= async() => {
  const createResponse = await api.getUserDetails();
  console.log(createResponse);
  if (!createResponse || createResponse.error) {
	user_is_client.value = false;
  }else{
	user_is_client.value = true;
	clientUser.value = createResponse;
	
  }
}
const route = useRoute();
const fromDashboard = route.query.fromDashboard ?? false;
if(fromDashboard){
	filter_import.value = 'FOR ASSESSMENT'
  selectedChips.value.push('FOR ASSESSMENT')
}

const addChip = () => {
  if (filter.value.trim() !== '') {
    selectedChips.value.push(filter.value.trim());
    filter.value = '';
  }
};

const removeChip = (chip) => {
  const index = selectedChips.value.indexOf(chip);
  if (index > -1) {
    selectedChips.value.splice(index, 1);
  }
  filter_import.value = ''
};
// console.log(fromDashboard)
const user_is_client = ref(false)
const store = auth()
const {keycloak,getName} = storeToRefs(store)
const hasPermission = (authority) => {
  if (keycloak.value.realmAccess.roles.includes(authority)) {
	console.log("keycloak",true)
	return true;
  }
  return false;
}

 const loadData = () => {
  loading.value = true;
  api
	.getImportPreAssessments(0, 0, "")
	.then((response) => {
  	console.log(response.importPreAssessments);
  	tablerows.value = response.importPreAssessments;
  	

	  loading.value = false;
	})
	.catch(() => {
  	loading.value = false;
  	$q.notify({
    	color: "negative",
    	position: "top",
    	message: "Loading failed",
    	icon: "report_problem",
  	});
	});


	api
	.getExemptions(0, 0, "")
	.then((response) => {
  	console.log(response.exemptions);
  	listOfExemptions.value = response.exemptions;
  	
	})
	.catch(() => {

  	$q.notify({
    	color: "negative",
    	position: "top",
    	message: "Loading failed",
    	icon: "report_problem",
  	});
	});
	
};
loadData();


const gotoPayments = async (state, details) => {
  console.log("details",details);
  const createResponse = await api.updateImportPreAssessmentAsPaid(details);
 
  if (!createResponse || createResponse.error) {

  } else {
	paymentdata.value = {
  	id: details.id,
  	chargeReferenceNumber: details.transactionReferenceNumber,
  	amount: details.totalAmount,
  	transactiontype: "import"
	};
	ShowPayments.value = true;
  }
}
const loadDetails = async (params) => {
  loading.value = true;
  await api.getImportContainers(0, 0, params)
	.then((response) => {
  	console.log(response.importPreAssessment);
  	console.log(response.importContainers);
  	importPreAssessmentDetails.value = response.importPreAssessment;
  	importContainersDetails.value = response.importContainers;
	console.log(importPreAssessmentDetails.value)
	getSelectedExemptions();
	getPaymentDetails();
  	loading.value = false;
	formImportPreAsessmentDetails.value = true
	
	})
	.catch(() => {
  	loading.value = false;
  	$q.notify({
    	color: "negative",
    	position: "top",
    	message: "Loading failed",
    	icon: "report_problem",
  	});
	});
	
};

async function updateAllPreAssessmentContainers(){
	console.log("importPreAssessmentDetails Status",importPreAssessmentDetails.value.status)
	console.log("importContainersDetails",importContainersDetails.value)
	if((importPreAssessmentDetails.value.status == "COMPLETE")||(importPreAssessmentDetails.value.status == "INCOMPLETE")){
		
		for(let i = 0; i < importContainersDetails.value.length; i++) {
			var date1 = new Date(importContainersDetails.value[i].dateStorageValidUntil)
			var date2 = new Date()
			var Difference_In_Time = date2.getTime() - date1.getTime()
			var Difference_In_Days = Math.round(Difference_In_Time / (1000 * 3600 * 24))
			if(date1 >= date2){
				Difference_In_Days = 0
			}else{
				const storage_instance = await getStorage(importPreAssessmentDetails.value.transactionType,importContainersDetails.value[i].size,Difference_In_Days)
				console.log(storage_instance);
				importContainersDetails.value[i].storage = storage_instance.importStoragesTariff
			}
			var container_to_be_updated = {
				bulk: importContainersDetails.value[i].bulk,
				containerNumber: importContainersDetails.value[i].containerNumber,
				createdBy: importContainersDetails.value[i].createdBy,
				dateCreated: importContainersDetails.value[i].dateCreated,
				dateStorageValidUntil: importContainersDetails.value[i].dateStorageValidUntil,
				dg: importContainersDetails.value[i].dg,
				containerId: importContainersDetails.value[i].id,
				importPreAssessmentId: importContainersDetails.value[i].importPreAssessment,
				lastUpdated: importContainersDetails.value[i].lastUpdated,
				lastUpdatedBy: importContainersDetails.value[i].lastUpdatedBy,
				oc: importContainersDetails.value[i].oc,
				penalty: importContainersDetails.value[i].penalty,
				size: importContainersDetails.value[i].size,
				storage: importContainersDetails.value[i].storage,
				totalAmount: importContainersDetails.value[i].totalAmount,
				wharfage: importContainersDetails.value[i].wharfage
			}
			console.log("importContainersDetails",container_to_be_updated)
			updateContainer(container_to_be_updated);
			continue;
		}
	}
}

const getSelectedExemptions = (params) => {

if(!importPreAssessmentDetails.value.exemption)importPreAssessmentDetails.value.exemption = '';
let xlist = importPreAssessmentDetails.value.exemption.split(',');
console.log(xlist);
	for(let i=0;i<listOfExemptions .value.length;i++){
		  let x_code = listOfExemptions .value[i].code??"";
		  console.log('add',x_code);
		  if(xlist.some(x=> x===x_code)){
			if(!selectedExemption.value.some(a=>a===x_code))
			  selectedExemption.value.push(x_code);
			console.log('adds',x_code);
		  }
	}
	console.log(selectedExemption.value)
}

 const isDisabled_input = () => {
      if(isAssessor() && importPreAssessmentDetails.value.status === 'FOR ASSESSMENT')
        return false;
      if(user_is_client.value && importPreAssessmentDetails.value.status.includes('COMPLETE'))
        return false;  
      return true;
    };

	const isAssessor = () => {
    if (keycloak.value.realmAccess.roles.some((x) => x === "GROUP_CPA_ASSESSOR")) {
      return true;
    }
    return false;
  };

 const create = (importDetails) => {
  formImport.value = true
  loading.value = true;
  api
	.createImportpreAssessment(importDetails.code, importDetails.description)
	.then((response) => {
  	console.log(response.exemptions);
  	// tablerows.value = response.exemptions;
  	loading.value = false;
  	formImport.value = false;
  	onReset();
	})
	.catch(() => {
  	loading.value = false;
  	$q.notify({
    	color: "negative",
    	position: "top",
    	message: "Process failed",
    	icon: "report_problem",
  	});
	});
};


 const update = (importDetails) => {
  formImport.value = true
  loading.value = true;
  api
	.updateExemption(importDetails.code, importDetails.description)
	.then((response) => {
  	console.log(response.exemptions);
  	loading.value = false;
  	formImport.value = false;
  	onReset();
	})
	.catch(() => {
  	loading.value = false;
  	$q.notify({
    	color: "negative",
    	position: "top",
    	message: "Process failed",
    	icon: "report_problem",
  	});
	});
};

 const createImportpreAssessment = () => {
  titleForm.value = "Create Import Pre-Assessment"
  onReset();
  encodingInput.value.transactionType="Loaded"
  formImport.value = true
  addTransaction.value = true
}

const computeEWT = () =>{
    console.log("wew")
    if(encodingInput.value.has_EWT === false){
		encodingInput.value.withholdingTax = "0.00";
	}
    else{
        let old_amount = Number(encodingInput.value.amount??0);
        if(old_amount>0){
          old_amount -= Number(encodingInput.value.arrastre??0);
        }
        let new_amount = old_amount + Number(StringToNumber(encodingInput.value.arrastre));
        // amount += Number(importAddStoDetails.value.arrastre);
        console.log("amount", new_amount);
        encodingInput.value.withholdingTax = Number((new_amount*0.02 ).toFixed(2))  
    }
}


const searchEtradeImportPreAssesment = async () => {
 	loading.value = true;
	searching.value = true;
 	
	const duplicates = await api.getImportPreAssessmentDuplicates(searchImportInput.value.blNo,searchImportInput.value.registryNo,searchImportInput.value.entryNo)
	console.log(duplicates.empty)
	if (!duplicates || duplicates.error || !duplicates.empty) {
		$q.notify({
			color: "negative",
			position: "top",
			message: "import pre-assessment application already exist",
			icon: "report_problem",
		});
		loading.value = false;
		searching.value = false;
	}else{
		await api
		.getEtradeImportPreAssesmentData(searchImportInput.value)
		.then(async (response) => {
			console.log("this is the response of getEtradeImportPreAssesmentData: ", response);
			console.log(response.error?.response.data)
			if((response.error?.response.data)){
				try {
					if((response.error?.response.data).includes('Error Getting Data: null')){
						$q.notify({
							color: "negative",
							position: "top",
							message: "No Data Found",
							icon: "report_problem",
						});
						loading.value = false;
						searching.value = false;
					}
					else{
						$q.notify({
							color: "negative",
							position: "top",
							message: response.error?.response.data ?? "Error Getting Data",
							icon: "report_problem",
						});
						loading.value = false;
						searching.value = false;
					}
				} catch (error) {
					$q.notify({
						color: "negative",
						position: "top",
						message: "No Data Found",
						icon: "report_problem",
					});
					loading.value = false;
					searching.value = false;
				}
			}
			encodingInput.value.blNo = response.blNo ?? searchImportInput.value.blNo ?? null
			encodingInput.value.broker = response.broker ?? null
			encodingInput.value.brokerTin = response.broker_tin ?? null
			encodingInput.value.commodity = response.commodity ?? null
			encodingInput.value.consigneeName = response.consignee.trim() ?? null
			encodingInput.value.consigneeAddress = response.consignee_address ?? null
			encodingInput.value.consigneeTin = response.consignee_tin ?? null
			encodingInput.value.entryNo = response.entry_no ?? searchImportInput.value.entryNo ?? null
			encodingInput.value.registryNo = response.registryNo ?? searchImportInput.value.registryNo ?? null
			encodingInput.value.vessel = response.vessel ?? null
			encodingInput.value.voyageNo = response.voyage_no ?? null
			encodingInput.value.lastDischargeDate = response.last_discharge_date ?? '2022-12-01'
			encodingInput.value.containers = response.containers ?? null
			encodingInput.value.storageStartDate = response.storage_start_date ?? '2022-12-06'
			await api.getUserDetails()
			.then(async (response) => {
				const user_fullname = response.firstname+" "+response.lastname
				if(response.roles.includes("GROUP_CLIENT_IMPORTER_EXPORTER")){
					encodingInput.value.consigneeName = user_fullname
					encodingInput.value.consigneeAddress = response.address
					encodingInput.value.consigneeTin = response.tin
				}
				if(response.roles.some((x) => x === "GROUP_CLIENT_BROKER")){
					encodingInput.value.broker = user_fullname
					encodingInput.value.brokerTin = response.tin
				}
				encodingInput.value.clientOwner = response.clientOwner
			})
			.catch(() => {
				console.log("wew"+ response)
				$q.notify({
					color: "negative",
					position: "top",
					message: "error getting user details",
					icon: "report_problem",
				});
				loading.value = false;
				searching.value = false;
			});
			encodingInput.value.formType = 'CREATED'

			await saveImportPreAssessment(encodingInput)
		})
	}
};

const saveImportPreAssessment = async (data) => {
	console.log("TADA!",data)
	if(data){
		if(data.value.formType === 'CREATED'){
			// $q.notify({
			// 	color: "positive",
			// 	position: "top",
			// 	message: "creating import pre-assessment",
			// });
			const createResponse  = await api.createImportPreAssessment(data);
			if (!createResponse || createResponse.error) {
				$q.notify({
					color: "negative",
					position: "top",
					message: createResponse.error ?? "error creating import pre-assessment",
					icon: "report_problem",
				});
				loading.value = false;
				searching.value = false;
            } else {
				
				queryCreatedImportPreAssesment.value.consigneeName = data.value.consigneeName
              	queryCreatedImportPreAssesment.value.blNo = data.value.blNo
              	queryCreatedImportPreAssesment.value.entryNo = data.value.entryNo
				
				$q.notify({
					color: "positive",
					position: "top",
					message: "Created Import pre-assessment",
				});

				getCreatedImportPreAssesment()

				loading.value = false;
				searching.value = false;
				formImport.value = false
				loadData();

			}
		}
	}
}

async function getCreatedImportPreAssesment(){
	console.log("TEEEST")
	const importPreAssessmentsListResponse = await api.getImportPreAssessments(0,1,queryCreatedImportPreAssesment.value);
	if (!importPreAssessmentsListResponse || importPreAssessmentsListResponse.error) {
        console.log(`${importPreAssessmentsListResponse.error}`);

		$q.notify({
					color: "negative",
					position: "top",
					message: importPreAssessmentsListResponse.error ?? "error getting import pre-assessment",
					icon: "report_problem",
				});
    } else {
		console.log("Created import pre-assessment",importPreAssessmentsListResponse.importPreAssessments[0].transactionType);
		//encodingInput.value.containers
		if(importPreAssessmentsListResponse.importPreAssessments[0].transactionType == "Bulk"){
			//$q.notify({
			//	color: "positive",
			//	position: "top",
			//	message: "no containers tobe created",
			//});
			const params = ref({
				importPreAssessmentId: importPreAssessmentsListResponse.importPreAssessments[0].id,
				containerNumber: 'Bulk',
				size: 'Bulk',
				wharfage: '0.00',
				bulk: '0.00',
				storage: '0.00',
				dg: '0.00',
				oc: '0.00',
				dateStorageValidUntil: '',
				penalty: '0.00',
			})
			
			let param = {
				storageStartDate: encodingInput.value.storageStartDate,
				dateStorageValidUntil: "",
				grossweight: encodingInput.value.grossweight,
				cbm: encodingInput.value.cbm
			}
			const warfage_instance = await api.getImportWarfageBULK(param)
			if (!warfage_instance || warfage_instance.error) {
				console.log(`${warfage_instance.error}`);
				$q.notify({
					color: "negative",
					position: "top",
					message: warfage_instance.error ?? "error getting warfage amount",
					icon: "report_problem",
				});
			} else {
				params.value.wharfage = warfage_instance.wharfage_tariff
			}
			if(importPreAssessmentsListResponse.importPreAssessments[0].storageStartDate){
				var dateStorageValidUntil = importPreAssessmentsListResponse.importPreAssessments[0].storageStartDate
				params.value.dateStorageValidUntil = dateStorageValidUntil;
			
			}else{
				var lastDischargeDate = importPreAssessmentsListResponse.importPreAssessments[0].lastDischargeDate
				var dateStorageValidUntil = new Date(lastDischargeDate);
				dateStorageValidUntil.setDate(dateStorageValidUntil.getDate() + 5 )
				params.value.dateStorageValidUntil = dateStorageValidUntil;
			}
			createContainer(params.value)
			viewImport(importPreAssessmentsListResponse.importPreAssessments[0].id)
		}else{
			if(encodingInput.value.containers){
				if(importPreAssessmentsListResponse.importPreAssessments[0].storageStartDate){
					
					var dateStorageValidUntil = importPreAssessmentsListResponse.importPreAssessments[0].storageStartDate

					autoCreateContainers(importPreAssessmentsListResponse.importPreAssessments[0].id,dateStorageValidUntil,encodingInput.value.containers)
				
					
					
				
				}else{
					var lastDischargeDate = importPreAssessmentsListResponse.importPreAssessments[0].lastDischargeDate
					var dateStorageValidUntil = new Date(lastDischargeDate);
					dateStorageValidUntil.setDate(dateStorageValidUntil.getDate() + 5 )

					autoCreateContainers(importPreAssessmentsListResponse.importPreAssessments[0].id,dateStorageValidUntil,encodingInput.value.containers)

					
				}
			}else{
				$q.notify({
					color: "positive",
					position: "top",
					message: "no containers tobe created",
				});
				onReset();
			}
			
		}
	}
}

async function autoCreateContainers(preAssessmentID,storageValidUntil,containers){
	for(var i = 0; i < containers.length; i++){
		var container = {}
		container.importPreAssessmentId = preAssessmentID.toString()
		container.containerNumber = containers[i].reference
		container.size = containers[i].type
		container.dateStorageValidUntil = storageValidUntil;
		try{
			if((encodingInput.value.transactionType)&&(container.size)){
				if(encodingInput.value.transactionType == 'Bulk'){
					let params = {
						storageStartDate: encodingInput.value.storageStartDate,
						dateStorageValidUntil: container.dateStorageValidUntil,
						grossweight: encodingInput.value.grossweight,
						cbm: encodingInput.value.cbm
					}
					const warfage_instance = await api.getImportWarfageBULK(params)
					if (!warfage_instance || warfage_instance.error) {
						console.log(`${warfage_instance.error}`);
						$q.notify({
							color: "negative",
							position: "top",
							message: warfage_instance.error ?? "error getting warfage amount",
							icon: "report_problem",
						});
					} else {
						container.wharfage = warfage_instance.wharfage_tariff
					}
					
				}else{
					const warfage_instance = await getWarfage(encodingInput.value.transactionType,container.size)
					if(warfage_instance){
						if(warfage_instance.whRate){
							container.wharfage = warfage_instance.whRate
						}
					}
				}

				var date1 = new Date(container.dateStorageValidUntil)
				var date2 = new Date()
				var Difference_In_Time = date2.getTime() - date1.getTime()
				var Difference_In_Days = Math.round(Difference_In_Time / (1000 * 3600 * 24))
				if(date1 >= date2){
					Difference_In_Days = 0
				}else{
					console.log(Difference_In_Days)

					const storage_instance = await getStorage(encodingInput.value.transactionType,container.size,Difference_In_Days)
					console.log(storage_instance);
					container.storage = storage_instance.importStoragesTariff
				}
			}
		}catch (error) {

		}

		createContainer(container)
	}
	viewImport(preAssessmentID);
	// loadDetails(importPreAssessmentDetails.value.id);
}


async function getWarfage(subType,size){
	console.log(subType,size)
	const warfage_instance = await api.getWharfageInstance("IMPORT",subType,size)
	if (!warfage_instance || warfage_instance.error) {
        console.log(`${warfage_instance.error}`);

		$q.notify({
			color: "negative",
			position: "top",
			message: warfage_instance.error ?? "error getting warfage amount",
			icon: "report_problem",
		});
		return null
    } else {
		return warfage_instance
	}
}

async function getStorage(subType,size,noOfDays){
	console.log(subType,size)
	const storage_instance = await api.getStorageInstance("IMPORT",subType,size,noOfDays)
	if (!storage_instance || storage_instance.error) {
        console.log(`${storage_instance.error}`);

		$q.notify({
			color: "negative",
			position: "top",
			message: storage_instance.error ?? "error getting storage amount",
			icon: "report_problem",
		});
		return null
    } else {
		return storage_instance
	}
}

const loading_message = ref("");
const notification = ref(false);
const update_dialog_value = (val) => {
  dialoge_response.value = val
}

const autoInputContainerForm = async () =>{
	if((importPreAssessmentDetails.value.transactionType)&&(container_form_data.value.size)){
		if(importPreAssessmentDetails.value.transactionType == 'Bulk'){
			let params = {
                storageStartDate: importPreAssessmentDetails.value.storageStartDate,
                dateStorageValidUntil: container_form_data.value.dateStorageValidUntil,
                grossweight: importPreAssessmentDetails.value.grossweight,
                cbm: importPreAssessmentDetails.value.cbm
            }
			const warfage_instance = await api.getImportWarfageBULK(params)
			if (!warfage_instance || warfage_instance.error) {
				console.log(`${warfage_instance.error}`);
				$q.notify({
					color: "negative",
					position: "top",
					message: warfage_instance.error ?? "error getting warfage amount",
					icon: "report_problem",
				});
			} else {
				container_form_data.value.wharfage = warfage_instance.wharfage_tariff
			}
			
		}else{
			const warfage_instance = await getWarfage(importPreAssessmentDetails.value.transactionType,container_form_data.value.size)
			if(warfage_instance){
				if(warfage_instance.whRate){
					container_form_data.value.wharfage = warfage_instance.whRate
				}
			}
			console.log(warfage_instance);
		}

		var date1 = new Date(container_form_data.value.dateStorageValidUntil)
		var date2 = new Date()
		var Difference_In_Time = date2.getTime() - date1.getTime()
		var Difference_In_Days = Math.round(Difference_In_Time / (1000 * 3600 * 24))
		if(date1 >= date2){
			Difference_In_Days = 0
		}else{
			console.log(Difference_In_Days)
			const storage_instance = await getStorage(importPreAssessmentDetails.value.transactionType,container_form_data.value.size,Difference_In_Days)
			console.log(storage_instance);
			container_form_data.value.storage = storage_instance.importStoragesTariff
		}
		
	}
}

const OncreateContainer = () => {
  container_form_data.value.importPreAssessmentId = importPreAssessmentDetails.value.id
  container_form_data.value.containerNumber = null
  container_form_data.value.size = null
  container_form_data.value.wharfage = null
  container_form_data.value.bulk = null
  container_form_data.value.storage = null
  container_form_data.value.dg = null
  container_form_data.value.oc = null
  container_form_data.value.penalty = null
  container_form_data.value.dateStorageValidUntil = null
  container_form_data.value.containerId = null
  onReset();
  formContainer.value = true
  is_container_creation.value = true
}


  
const OnupdateContainer = (val) => {
  onReset();
  container_form_data.value.containerId = val.row.id
  container_form_data.value.containerNumber = val.row.containerNumber
  container_form_data.value.size = val.row.size
  container_form_data.value.wharfage = val.row.wharfage
  container_form_data.value.bulk = val.row.bulk
  container_form_data.value.storage = val.row.storage
  container_form_data.value.dg = val.row.dg
  container_form_data.value.oc = val.row.oc
  container_form_data.value.penalty = val.row.penalty
  container_form_data.value.dateStorageValidUntil = val.row.dateStorageValidUntil
  container_form_data.value.importPreAssessmentId = importPreAssessmentDetails.value.id
  console.log("Form data",container_form_data)
  
  formContainer.value = true
  is_container_creation.value = false
}
const clearContainerForm=() => {
  
  container_form_data.value.containerNumber = null
  container_form_data.value.size = null
  container_form_data.value.wharfage = null
  container_form_data.value.bulk = null
  container_form_data.value.storage = null
  container_form_data.value.dg = null
  container_form_data.value.oc = null
  container_form_data.value.penalty = null
  container_form_data.value.dateStorageValidUntil = null
}
const createContainer = async (val) => {
  searching.value = true;
  const createResponse=await api.createImportContainer(val);
  console.log(createResponse);

  if (!createResponse || createResponse.error) {
	$q.notify({
    	color: "negative",
    	position: "top",
    	message: createResponse.error ?? "Process failed",
    	icon: "report_problem",
  	});
	  searching.value = false;

  }
  else{
	$q.notify({
    	color: "positive",
    	position: "top",
    	message: createResponse,
  	});
	await api
	.getImportContainers(0, 0, val.importPreAssessmentId)
		.then((response) => {
			importContainersDetails.value = response.importContainers;
		})
		.catch(() => {
			$q.notify({
				color: "negative",
				position: "top",
				message: "Loading failed",
				icon: "report_problem",
			});
		});
	searching.value = false;
	formContainer.value = false;
  }

}
const updateContainer = async (val) => {
	searching.value = true;
  const createResponse=await api.updateImportContainer(val);
  console.log(createResponse);

  if (!createResponse || createResponse.error) {
	$q.notify({
    	color: "negative",
    	position: "top",
    	message: "Process failed",
    	icon: "report_problem",
  	});
	  searching.value = false;

  }
  else{
	$q.notify({
    	color: "positive",
    	position: "top",
    	message: createResponse,
  	});

	  loadDetails(importPreAssessmentDetails.value.id);
	
	  searching.value = false;
	  formContainer.value = false;
  }
  
}
const deleteContainer = async (val) => {  
  $q.dialog({
    title: 'Warning!',
    message: 'Your about to delete import container with container number: '+val.row.containerNumber,
    cancel: true,
    persistent: true
  }).onOk(async () => {
    console.log("prop",val.row);
	loading.value = true;
    if(val.row){
      const removeResponse = await api.removeImportContainer(val.row);
	  if (!removeResponse || removeResponse.error) {
	$q.notify({
    	color: "negative",
    	position: "top",
    	message: removeResponse.error ?? "Process failed",
    	icon: "report_problem",
  	});
	  loading.value = false;
	  searching.value = false;

  }
  else{
	$q.notify({
    	color: "positive",
    	position: "top",
    	message: removeResponse,
  	});

	  loadDetails(importPreAssessmentDetails.value.id);
	  loading.value = false;
	  searching.value = false;
	  formContainer.value = false;
  }

    
    }
  }).onCancel(() => {
  })
}
const updateApplicationState = async(state, details) => {
	stateUpdate.value = true;
  if (state === "APPLY") {
    if(importContainersDetails.value.length>0 || details.transactionType == 'Bulk'){
      
      setTimeout(async () => {
        const createResponse = await api.updateImportPreAssessmentAsApplied(
          details
        );
        console.log(createResponse);
        
        if (!createResponse || createResponse.error) {
			$q.notify({
				color: "negative",
				position: "top",
				message: createResponse.error,
				icon: "report_problem",
			});
			stateUpdate.value = false;
        } else {
			$q.notify({
				color: "positive",
				position: "top",
				message: `Successfully Applied Import Pre-Assessment`,
				
			});
			stateUpdate.value = false;
			formImportPreAsessmentDetails.value = false;
			
			
        }
      }, 2000);
    }else{
		$q.notify({
				color: "negative",
				position: "top",
				message: `Need to add container first to apply`,
				icon: "report_problem",
			});
			stateUpdate.value = false;
     
    }
  }
}
const updateApprovalState = (state, details) => {
	stateUpdate.value = true;
  if (state === "APPROVED") {
  
    if(process.env.VUE_APP_WALLET_IS_ENABLED === "true"){          
      setTimeout(async () => {
        let owner = ""
        if(details.clientOwner){
          owner = details.clientOwner
        }else{
          owner = details.createdBy
        }
        const getAccountNumResponse = await api.getWalletAccountNumber(
          owner
        );
        console.log(getAccountNumResponse);
        if (!getAccountNumResponse || getAccountNumResponse.error) {        
			$q.notify({
				color: "negative",
				position: "top",
				message: "Wallet account for client does not exist",
				icon: "report_problem",
			});
			stateUpdate.value = false;
        } else {
          paymentdata.value = {
            account_id: getAccountNumResponse.id,
            account_name: owner,
            account_number: getAccountNumResponse.accountNumber,
            transactionReferenceNumber: details.transactionReferenceNumber,
            amount: "50",
          };
          console.log(paymentdata);
          setTimeout(async () => {
            const transferResponse = await api.WalletPayment(
              paymentdata.value
            );
            console.log(transferResponse);
            if (!transferResponse || transferResponse.error) {
				$q.notify({
				color: "negative",
				position: "top",
				message: "Client wallet has insufficient funds",
				icon: "report_problem",
			});
			stateUpdate.value = false;
            } else {
              setTimeout(async () => {
                const createResponse =
                  await api.updateImportPreAssessmentAsApproved(details);
                console.log(createResponse);
                if (!createResponse || createResponse.error) {
					$q.notify({
						color: "negative",
						position: "top",
						message: createResponse.error,
						icon: "report_problem",
					});
					stateUpdate.value = false;
                } else {
					$q.notify({
						color: "positive",
						position: "top",
						message: `Successfully Approved Import Pre-Assessment`,
						
					});
					importPreAssessmentDetails.value.status = 'ASSESSED';
			
					//formImportPreAsessmentDetails.value = false;
					stateUpdate.value = false;
                  	// this.$refs.PorterForm.resetForm() 
                }
              }, 2000);
            }
          }, 2000);
        }
      }, 2000);
    }else{
              setTimeout(async () => {
                const createResponse =
                  await api.updateImportPreAssessmentAsApproved(details);
                console.log(createResponse);
                if (!createResponse || createResponse.error) {
					$q.notify({
						color: "negative",
						position: "top",
						message: createResponse.error,
						icon: "report_problem",
					});
                } else {
					$q.notify({
					color: "positive",
					position: "top",
					message: `Successfully Approved Import Pre-Assessment`,
					
				});
				stateUpdate.value = false;
				importPreAssessmentDetails.value.status = 'ASSESSED';
                  // this.$refs.PorterForm.resetForm() 
                }
              }, 2000);
    }
  } else if (state === "REJECTED") {
    // this.loadingMessage = `Rejecting Import Pre-Assessment`;
    setTimeout(async () => {
      const createResponse = await api.updateImportPreAssessmentAsRejected(
        details
      );
      console.log(createResponse);
      if (!createResponse || createResponse.error) {
        $q.notify({
						color: "negative",
						position: "top",
						message: createResponse.error,
						icon: "report_problem",
					});
					stateUpdate.value = false;
      } else {

		$q.notify({
					color: "positive",
					position: "top",
					message: `Successfully Rejected Import Pre-Assessment`,
					
				});
		stateUpdate.value = false;
		importPreAssessmentDetails.value.status = 'DISAPPROVED';
        // this.$refs.PorterForm.resetForm()
      }
    }, 2000);
  } else  if (state === 'CANCELLED'){
                
      
  
                $q.dialog({
                  title: "Import Pre Assessment Cancellation",
                  message: "Are you sure you want to cancel?",
                  cancel: true,
                }).onOk(() => {
                  cancelling.value = true;
                  api
                    .updateImportPreAssessmentAsCancelled(importPreAssessmentDetails.value)
                    .then((response) => {
                      
                      if(response.error){
                      $q.notify({
                      color: "negative",
                      position: "top",
                      message: response.error.response?.data.message ?? 'Failed to Cancel',
                      icon: "report_problem",
                    });
                    stateUpdate.value = false;
                    cancelling.value = false;
                    }
                    else{
                      $q.notify({
                      // position: 'top',
                      color: "green-4",
                      textColor: "white",
                      icon: "cloud_done",
                      position: "top",
                      message: "Import Pre Assessment has been cancelled!",
                    });
                    importPreAssessmentDetails.value.status = "CANCELLED"
                    }
					stateUpdate.value = false;
                    cancelling.value = false;
                    formRemarks.value = false;
                    
                    })
                    .catch((e) => {
						stateUpdate.value = false;
                    cancelling.value = false;
                    formRemarks.value = false;
                      $q.notify({
                        position: "top",
                        color: "negative",
                        position: "top",
                        message: e.message ?? "Failed to cancel Import Pre Assessment",
                        icon: "report_problem",
                      });
                      
                    });
                });
                      // const createResponse = await API.updateImportPreAssessmentAsRejected(details)
                   
              }
}
const downloadFcwpImportPreAssessment = async(details) => {
  const downloadResponse = await api.downloadFcwpImportPreAssessment(details.transactionReferenceNumber)
  
  if (!downloadResponse || downloadResponse.error) {

	$q.notify({
                      color: "negative",
                      position: "top",
                      message: (downloadResponse.error.toString()).includes('object') ? 'Error downloading FCWP: file not found.' : downloadResponse.error,
                      icon: "report_problem",
                    });
 
  } else {
	$q.notify({
                      // position: 'top',
                      color: "green-4",
                      textColor: "white",
                      icon: "cloud_done",
                      position: "top",
                      message: "Download FCWP complete.",
                    });
  
  }
}

const deleteApplication = async(details) => {
  $q.dialog({
    title: 'Warning!',
    message: 'Are you sure you want delete this Application?',
    cancel: true,
    persistent: true
  }).onOk(async () => {
    if(details){
      const deleteImportRespnse = await api.deleteImportPreAssessment(
        details
      );
      if (!deleteImportRespnse || deleteImportRespnse.error) {

		$q.notify({
                      color: "negative",
                      position: "top",
                      message: deleteImportRespnse.error ?? 'Failed to delete',
                      icon: "report_problem",
                    });

      } else {

		$q.notify({
                      // position: 'top',
                      color: "green-4",
                      textColor: "white",
                      icon: "cloud_done",
                      position: "top",
                      message: "Successfully deleted",
                    });
    
          formImportPreAsessmentDetails.value = false
       
      }
    }
  }).onCancel(() => {
  })
}
const downloadOrImportPreAssessment = async (state, count, details) => {
  const file = ref("")
  if (count === "1") {
    file.value = details.filename;
  } else if (count === "2") {
    file.value = details.filename2;
  } else if (count === "3") {
    file.value = details.filename3;
  } else if (count === "4") {
    file.value = details.filename4;
  } else if (count === "5") {
    file.value = details.filename5;
  }
  const downloadResponse = await api.downloadOrImportPreAssessment(
    file.value,
    count
  );
  console.log('hashem', downloadResponse,downloadResponse.error ?'as':'sa');
  if (!downloadResponse || downloadResponse.error) {

	$q.notify({
                      color: "negative",
                      position: "top",
                      message: (downloadResponse.error.toString()).includes('object') ? 'Error Fetching OR: file not found.' : downloadResponse.error,
                      icon: "report_problem",
                    });
 
  } else {
    //console.log("dataType", downloadResponse.data.type);
    //const blob = new Blob([downloadResponse.data],{type:downloadResponse.data.type});
    //const objectUrl = URL.createObjectURL(blob);
    //this.OR_data = objectUrl;
    //this.isPDF = !(downloadResponse.data.type).includes('image');
    //this.showOR = true;

	$q.notify({
                      // position: 'top',
                      color: "green-4",
                      textColor: "white",
                      icon: "cloud_done",
                      position: "top",
                      message: "Download OR:",
                    });
 
  }
}

const createEncoding = () => {
	for (let pI in encodingInput.value) {
		encodingInput.value[pI] = null;
	}
	
	onReset();
	if(hasPermission('ROLE_CLIENT_BROKER')){
		console.log('brokerName',getName.value);
		encodingInput.value.broker = clientUser?.value.firstname == undefined ? getName.value : (clientUser?.value.firstname +" "+clientUser?.value.lastname);
		encodingInput.value.brokerTin = clientUser?.value.tin ?? '';	
	}
	
	if(hasPermission('ROLE_CLIENT_IMPORTER_EXPORTER')){
		encodingInput.value.consigneeName = clientUser?.value.firstname == undefined ? getName.value : (clientUser?.value.firstname +" "+clientUser?.value.lastname);
		encodingInput.value.consigneeAddress = clientUser?.value.address ?? '';
		encodingInput.value.consigneeTin = clientUser?.value.tin ?? '';
	}

	formEncoding.value = true
	formImport.value = false
	updateMode.value = false;
	encodingInput.value.formType = 'CREATED';
}

function uploadOrImportPreAssessment(file,count,details){
	let filetoUploadExists = false;
	if(count == '1'){
		if(details.filename){
			filetoUploadExists = true;
		}
		
	}
	else if(count == '2'){
		if(details.filename2){
			filetoUploadExists = true;
		}
		
	}
	else if(count == '3'){
		if(details.filename3){
			filetoUploadExists = true;
		}
		
	}
	else if(count == '4'){
		if(details.filename4){
			filetoUploadExists = true;
		}
		
	}
	else if(count == '5'){
		if(details.filename5){
			filetoUploadExists = true;
		}
		
	}
	
	if(!filetoUploadExists){
	
				if(file){
					if(count == '1'){
				
				uploading.value = true;

			}
			else if(count == '2'){
				
				uploading2.value = true;
			}
			else if(count == '3'){
				
				uploading3.value = true;
			}
			else if(count == '4'){
				
				uploading4.value = true;
			}
			else if(count == '5'){
				
				uploading5.value = true;
			}
			$q.notify({
			color: "positive",
			position: "top",
			message: "Uploading OR for Import Pre-Assessment.",
			});
			let formData = new FormData();
			formData.append("file", file);
    	    formData.append("importPreAssessmentId", details.id);
    	    formData.append("count", count);
			setTimeout(async () => {
    	        const uploadResponse = await api.uploadOrImportPreAssessment(
    	          formData
    	        );
    	        console.log(uploadResponse);
			
    	        if (!uploadResponse || uploadResponse.error) {
					$q.notify({
						color: "negative",
						position: "top",
						message: uploadResponse.error ?? "Error in Uploading file",
						icon: "report_problem",
					});
					uploading.value = false;
					uploading2.value = false;
					uploading3.value = false;
					uploading4.value = false;
					uploading5.value = false;
    	        } else {
    	          	$q.notify({
						color: "positive",
						position: "top",
						message: "Successfully Uploaded OR for Import Pre-Assessment.",
					});

					let pastID = details.id;
					loadDetails(pastID);
					uploading.value = false;
					uploading2.value = false;
					uploading3.value = false;
					uploading4.value = false;
					uploading5.value = false;

    	        }
    	    }, 2000);
		}
		else{
			$q.notify({
			color: "negative",
			position: "top",
			message: "Please select a file",
			icon: "report_problem",
		});
		uploading.value = false;
		}
	}else{
		$q.notify({
			color: "negative",
			position: "top",
			message: "OR file already exists",
			icon: "report_problem",
		});
	}
}

 const EditPorter = (val) => {
  titleForm.value = "Update Payment Agent"
  onReset();
  importDetails.value = val.row
  console.log(importDetails.value);
  formImport.value = true
}
const viewImport = async (val) => {
	paymentDetails.value = {
		transactionReferenceNumber: null,
		paymentType: null,
		orNo: null,
		
	}
	or_file_1.value = null;
	or_file_2.value = null;
	or_file_3.value = null;
	or_file_4.value = null;
	or_file_5.value = null;
  importPreAssessmentDetails.value = ([]);
 
  selectedExemption.value = []
  tab.value = "details";
  await loadDetails(val);
  updateAllPreAssessmentContainers();
}
 const createOrEdit = (importDetails) => {
  if (titleForm.value === "Create New Agency") {
	create(importDetails);
  } else if (titleForm.value === "Update Payment Agent") {
	update(importDetails)
  }
}
 const onReset = () => {
  for (let pI in importDetails.value) importDetails.value[pI] = null;
 
  cargoType.value = "";
  searchImportInput.value = ([]);
  loadData();
};
 function wrapCsvValue(val, formatFn, row) {
  let formatted = formatFn !== void 0 ? formatFn(val, row) : val;
   formatted =
	formatted === void 0 || formatted === null ? "" : String(formatted);
   formatted = formatted.split('"').join('""');
  /**
   * Excel accepts \n and \r in strings, but some other CSV parsers do not
   * Uncomment the next two lines to escape new lines
   */
  // .split('\n').join('\\n')
  // .split('\r').join('\\r')
   return `"${formatted}"`;
}
 const exportTable = () => {
  // naive encoding to csv format
  const content = [columnsImport.map((col) => wrapCsvValue(col.label))]
	.concat(
	tablerows.value.map((row) =>
    	columnsImport
      	.map((col) =>
        	wrapCsvValue(
          	typeof col.field === "function"
            	? col.field(row)
            	: row[col.field === void 0 ? col.name : col.field],
          	col.format,
          	row
        	)
      	)
      	.join(",")
  	)
	)
	.join("\r\n");
   const status = exportFile("table-export.csv", content, "text/csv");
   if (status !== true) {
	$q.notify({
  	message: "Browser denied file download...",
  	color: "negative",
  	icon: "warning",
	});
  }
};

const getPaymentDetails = async () =>{

	try {
    
	const paymentData = await api.getPaymentTransactions(0,1,importPreAssessmentDetails.value)
	paymentDetails.value.paymentType = null;
	paymentDetails.value.orNo = null;
	paymentDetails.value.transactionReferenceNumber = null;
	if (
	  !paymentData ||
	  paymentData.error
	) {
	  //error getting data
	  console.log(`${paymentData.error}`);
	} else {
	  console.log("PaymentDetail",paymentData.body.content[0])
	  if(paymentData.body.numberOfElements > 0){
		console.log("PaymentDetail",paymentData.body.content[0])
		if(paymentData.body.content[0].status == "Paid"){
		  if(paymentData.body.content[0].paymentType){
			paymentDetails.value.paymentType = paymentData.body.content[0].paymentType
		  }
		  if(paymentData.body.content[0].orNo){
			paymentDetails.value.orNo = paymentData.body.content[0].orNo
		  }
		  if(paymentData.body.content[0].transactionReferenceNumber){
			paymentDetails.value.transactionReferenceNumber = paymentData.body.content[0].transactionReferenceNumber
		  }
		}
	  }
	}
  }catch(err) {
	console.log(err.message);
  }
}

const exportTableContainer = () => {
  // naive encoding to csv format
  const content = [columnsContainers.map((col) => wrapCsvValue(col.label))]
	.concat(
	importContainersDetails.value.map((row) =>
    	columnsContainers
      	.map((col) =>
        	wrapCsvValue(
          	typeof col.field === "function"
            	? col.field(row)
            	: row[col.field === void 0 ? col.name : col.field],
          	col.format,
          	row
        	)
      	)
      	.join(",")
  	)
	)
	.join("\r\n");
   const status = exportFile("importpreassessment-export.csv", content, "text/csv");
   if (status !== true) {
	$q.notify({
  	message: "Browser denied file download...",
  	color: "negative",
  	icon: "warning",
	});
  }
};

const rules = {
	float: (v) => {
const numberValue = StringToNumber(v);
const stringValue = String(v);
return (
  (!isNaN(numberValue) && stringValue.indexOf('.') !== -1) ||
  (!isNaN(numberValue) && /^[0-9]*$/.test(stringValue))
) || "Must be a number";
},
requiredField: (v) => !!v || "Required field.",
requiredSelection: (v) => !!v || "Required at least one selection",
properEmail: (v) =>
  !v ||
  /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/.test(v) ||
  "E-mail must be valid. Ex. juandelacruz@apollo.com.ph",
matchPassword: (v) =>
  v === this.form.password || "Does not match new password.",
mobileNumber: (v) =>
  !v ||
  /^(09)\d{9}$/.test(v) ||
  "Mobile number must be valid. Ex. starts with (09) followed by xxxxxxxxx, where x = numeric character only",
maxLength: (v) => (v && v.length <= 12) || "Max 12 characters",
numbers: (v) =>
  (!isNaN(v) && /^[0-9.]*$/.test(v)) || "Must be positive numbers only",
currency: (v) =>
  /^[1-9]\d*(((,\d{3}){1})?(\.\d{0,2})?)$/.test(v) ||
  /^[1-9]\d*(((,\d{3}){2})?(\.\d{0,2})?)$/.test(v) ||
  /^[0]\.\d{0,2}$/.test(v) ||
  v === "0.00" ||
  v === "0" ||
  "Currency value only",

};











const StringToNumber = (value) => {
// Perform the necessary string to number conversion logic
    return Number(value);
  };










const isEditable = (importPreAssessment) => {
console.log("test")
    if(keycloak.value.realmAccess.roles.includes('ROLE_GOFAST_UPDATE_IMPORT_PRE_ASSESSMENT')){
      if (
      importPreAssessment.row.status === "COMPLETE" ||
      importPreAssessment.row.status === "INCOMPLETE"
        ) {
          return true;
        } else {
          return false;
        }

    }
    else if(keycloak.value.realmAccess.roles.includes('ROLE_GOFAST_UPDATE_ASSESSOR_IMPORT_PRE_ASSESSMENT')){
      if (importPreAssessment.row.status.includes("FOR ASSESSMENT")) {
      return true;
    } else {
      return false;
    }

    }
	else{

		return false;
	}


    
  }


  const editImport = (importPreAssessment) => {
	console.log(importPreAssessment.row)
	encodingInput.value = importPreAssessment.row;
	encodingInput.value.ewt = importPreAssessment.row.has_EWT;
	computeEWT()
	encodingInput.value.formType = 'UPDATE'
	formEncoding.value = true;
	updateMode.value = true;
  }

const createEncodingPreAssessment = async () => {
	searching.value = true;
	const duplicates = await api.getImportPreAssessmentDuplicates(encodingInput.value.blNo,encodingInput.value.registryNo,encodingInput.value.entryNo)
	if ((!duplicates || duplicates.error || !duplicates.empty)&&(encodingInput.value.formType == 'CREATED')) {
		$q.notify({
			color: "negative",
			position: "top",
			message: "import pre-assessment application already exist",
			icon: "report_problem",
		});
		loading.value = false;
		searching.value = false;
	}else{
		encodingInput.value.witholdingTax = encodingInput.value.withholdingTax ;
		encodingInput.value.transactionType = encodingInput.value.transactionType.value?? encodingInput.value.transactionType;
		console.log(encodingInput.value)
		if(encodingInput.value.formType == 'CREATED'){
			const createResponse  = await api.createImportPreAssessment(encodingInput);
			if (!createResponse || createResponse.error) {
				$q.notify({
					color: "negative",
					position: "top",
					message: "error creating import pre-assessment",
					icon: "report_problem",
				});
				loading.value = false;
				searching.value = false;
			} else {
				queryCreatedImportPreAssesment.value.consigneeName = encodingInput.value.consigneeName
				queryCreatedImportPreAssesment.value.blNo = encodingInput.value.blNo
				queryCreatedImportPreAssesment.value.entryNo = encodingInput.value.entryNo
				console.log("Created import pre-assessment",encodingInput.value)
				$q.notify({
					color: "positive",
					position: "top",
					message: "created import pre-assessment",
				});
				if(encodingInput.value.transactionType == 'Bulk'){
					const importPreAssessmentsListResponse = await api.getImportPreAssessments(0,1,queryCreatedImportPreAssesment.value);
					if (!importPreAssessmentsListResponse || importPreAssessmentsListResponse.error) {
						$q.notify({
							color: "negative",
							position: "top",
							message: "error getting import pre-assessment",
							icon: "report_problem",
						});
					}else{
						const params = ref({
							importPreAssessmentId: importPreAssessmentsListResponse.importPreAssessments[0].id,
							containerNumber: 'Bulk',
							size: 'Bulk',
							wharfage: '0.00',
							bulk: '0.00',
							storage: '0.00',
							dg: '0.00',
							oc: '0.00',
							dateStorageValidUntil: '',
							penalty: '0.00',
						})
						
						let param = {
							storageStartDate: encodingInput.value.storageStartDate,
							dateStorageValidUntil: "",
							grossweight: encodingInput.value.grossweight,
							cbm: encodingInput.value.cbm
						}
						const warfage_instance = await api.getImportWarfageBULK(param)
						if (!warfage_instance || warfage_instance.error) {
							console.log(`${warfage_instance.error}`);
							$q.notify({
								color: "negative",
								position: "top",
								message: warfage_instance.error ?? "error getting warfage amount",
								icon: "report_problem",
							});
						} else {
							params.value.wharfage = warfage_instance.wharfage_tariff
						}

						if(importPreAssessmentsListResponse.importPreAssessments[0].storageStartDate){
							var dateStorageValidUntil = importPreAssessmentsListResponse.importPreAssessments[0].storageStartDate
							params.value.dateStorageValidUntil = dateStorageValidUntil;
						
						}else{
							var lastDischargeDate = importPreAssessmentsListResponse.importPreAssessments[0].lastDischargeDate
							var dateStorageValidUntil = new Date(lastDischargeDate);
							dateStorageValidUntil.setDate(dateStorageValidUntil.getDate() + 5 )
							params.value.dateStorageValidUntil = dateStorageValidUntil;
						}

						createContainer(params.value)
					}
				}
				loading.value = false;
				searching.value = false;
				formEncoding.value = false;
				loadData();
			}
		}
		else if(encodingInput.value.formType == 'UPDATE'){
			console.log(encodingInput.value.witholdingTax)
			// encodingInput.value.transactionType = encodingInput.value.transactionType.value;
			const updateResponse = await api.updateImportPreAssessment(encodingInput.value);
			if (!updateResponse || updateResponse.error) {
					$q.notify({
						color: "negative",
						position: "top",
						message: updateResponse.error ?? "error updating import pre-assessment",
						icon: "report_problem",
					});
					loading.value = false;
					searching.value = false;
			} else {
				queryCreatedImportPreAssesment.value.consigneeName = encodingInput.value.consigneeName
				queryCreatedImportPreAssesment.value.blNo = encodingInput.value.blNo
				queryCreatedImportPreAssesment.value.entryNo = encodingInput.value.entryNo
				console.log("Updated import pre-assessment",encodingInput.value)
				$q.notify({
					color: "positive",
					position: "top",
					message: "Updated import pre-assessment",
				});
				loading.value = false;
				searching.value = false;
				formEncoding.value = false;
				loadData();
			}
		}
	}
}




  const exemptionListener = async () => {



 
  setTimeout(async() => {
      let param = {};
      param.id = importPreAssessmentDetails.value.id;
      param.exemptions = JSON.stringify(selectedExemption.value);
      const importPreAssessmentsListResponse = await api.updateImportExemption(param);
      if (!importPreAssessmentsListResponse || importPreAssessmentsListResponse.error) {
        $q.notify({
        position: "top",
            color: "negative",
            textColor: "white",
            icon: "report_problem",
            message: importPreAssessmentsListResponse?.error ?? "Failed to add Exemption",
          });
          
      } else { 
		importPreAssessmentDetails.value.filename = ''
          importPreAssessmentDetails.value =  importPreAssessmentsListResponse.data.importPreAssessment;
          // console.log(importPreAssessmentDetails.value)
          // this.numberOfPages = importPreAssessmentsListResponse.pageSize;          
          importContainersDetails.value = importPreAssessmentsListResponse.data.importContainers;
          
          $q.notify({
          position: "top",
              color: "green-4",
              textColor: "white",
              icon: "cloud_done",
              message: "Successfully Updated Exemption",
            });
          importPreAssessmentDetails.value.amount = thousandCommaSeparator(importPreAssessmentDetails.value.amount)
          importPreAssessmentDetails.value.arrastre = thousandCommaSeparator(importPreAssessmentDetails.value.arrastre)
          importPreAssessmentDetails.value.vat = thousandCommaSeparator(importPreAssessmentDetails.value.vat)
          importPreAssessmentDetails.value.withholdingTax = thousandCommaSeparator(importPreAssessmentDetails.value.withholdingTax)
          importPreAssessmentDetails.value.totalAmount = thousandCommaSeparator(importPreAssessmentDetails.value.totalAmount)
          
      } 
  }, 500);    
  
};


const cancelFormOpen = () => {

formRemarks.value = true;
}

const thousandCommaSeparator = (value) => {
return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
};


const removeOrFile = async(count,details, filename) => {
	let formData = new FormData();
			
    	    formData.append("importPreAssessmentId", details.id);
    	    formData.append("count", count);
			$q.dialog({
    title: 'Warning!',
    message: 'Your about to OR File: '+filename,
    cancel: true,
    persistent: true
  }).onOk(async () => {
	if(count == '1'){
		deletingOr.value = true;
	}
	else if(count == '2'){
		deletingOr2.value = true;
	}
	else if(count == '3'){
		deletingOr3.value = true;
	}
	else if(count == '4'){
		deletingOr4.value = true;
	}
	else if(count == '5'){
		deletingOr5.value = true;
	}
	

	const deleteResponse = await api.removeOrImportPreAssessment(
    	          formData
    	        );
    	        console.log(deleteResponse);
			
    	        if (!deleteResponse || deleteResponse.error) {
					$q.notify({
						color: "negative",
						position: "top",
						message: deleteResponse.error ?? "Error in Deleting file",
						icon: "report_problem",
					});
					deletingOr.value = false;
					deletingOr2.value = false;
					deletingOr3.value = false;
					deletingOr4.value = false;
					deletingOr5.value = false;
			
    	        } else {
    	          	$q.notify({
						color: "positive",
						position: "top",
						message: "Successfully Deleted OR for Import Pre-Assessment.",
					});
					
					let pastID = details.id;
					loadDetails(pastID);
					deletingOr.value = false;
					deletingOr2.value = false;
					deletingOr3.value = false;
					deletingOr4.value = false;
					deletingOr5.value = false;

    	        }

				or_file_1.value = null;
				or_file_2.value = null;
				or_file_3.value = null;
				or_file_4.value = null;
				or_file_5.value = null;
  })
	

}
</script>

<style scoped>
.boxed-input {
  border: 1px solid #ccc;
  border-radius: 4px;
  padding: 4px;
}

.chips-container {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
}

.cursor-pointer {
  cursor: pointer;
}
.updated {
  color: blue;
}
 .pending {
  color: red;
}
</style>