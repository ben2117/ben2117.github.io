---
layout: post
title:  "braintree and laravel"
date:   2017-12-22 11:11:00 +1100
categories: laravel
---
we should bootstrap our braintree service in AppServiceProvider.php

{% highlight php %}
namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Schema;

class AppServiceProvider extends ServiceProvider
{
	/**
	 * Bootstrap any application services.
	 *
	 * @return void
	 */
	 public function boot()
	{
		 //
		\Braintree_Configuration::environment( BRAINTREE ENVIRONMENT);
		\Braintree_Configuration::merchantId( BRAINTREE MERCHANT ID );
		\Braintree_Configuration::publicKey( BRAINTREE PUBLIC KEY );
		\Braintree_Configuration::privateKey( BRAINTREE PRIVATE KEY );
	}
	/**
	 *
	 * @return void
	 */
	public function register()
	{
		//
	}
}
{% endhighlight %}
we then create two routes. one to get the payment and one to post it. In web.php I have 
{% highlight php %}
Route::get('/payments/{quote}', 'PaymentController@getPayment')->middleware('auth');
Route::post('payments/acceptPayment', 'PaymentController@acceptPayment')->middleware('auth');
{% endhighlight %}
our payment controller has our two functions, getPyament which generates our braintree client token and sends that to our client and acceptPayment which makes the braintree transaction.
{% highlight php %}
public function getPyament($quote_id){
	$price = Quote::find($quote_id)->totalCost();
	$user = Auth::user();
	if(!$user->braintree_customer_id){
		$response = \Braintree_Customer::create([
   			'firstName' => $user->name,
   			'email' => $user->email
		]);
		if( $response->success) {
			$user->braintree_customer_id = $response->customer->id;
			$user->save();
		} else {
			return ($response);
		}
	}
	$clientToken = \Braintree_ClientToken::generate([
		"customerId" => $user->braintree_customer_id
	]);
 	return [
 		'braintree_customer_id' => $clientToken,
 		'quote_id' => $quote_id,
 		'price' => $price
	];
}
{%endhighlight%}
we create a customer if the current user does not already have a braintree id.
our view is done in vue. we use the mounted method to call  getPayment
{% highlight js %}
<template>
	<div>
		<form method="post">
			<div id="payment-form"></div>
			<md-button type="submit">Submit</md-button>
		</form>
	</div>
</template>

<script>
	export default {
		mounted() {
			axios.get('/payments/'+this.quoteId).then( response => {
				this.price = response.data.price;
				braintree.setup(response.data.braintree_customer_id , 'dropin', {
					container: 'payment-form',
					onPaymentMethodReceived: function (obj) {
						this.payment_method_nonce = obj.nonce;
						this.type = obj.type;
						this.details = obj.details;
						this.submitForm();
					}.bind(this)
				});
			}).catch(error => {
				console.log(error);
			});        	
		},
{%endhighlight%}
we use the onPaymentMethodReceived callback to add the data to our model and then call our submit form method to call our acceptPayment
{% highlight js %}
submitForm: function(){
	axios.post('payments/acceptPayment', this.$data)
		.then(response =>{
			alert("Your payment has been processed");
			console.log("success");
			router.push('/home');
		})
		.catch(error => {
			alert("There was an error with your payment");
			console.log(error)
		});
}
{%endhighlight%}
finally we get the nonce from the request and make the transaction. After the transaction is a success we save all the details to our database
{% highlight php %}
public function acceptPayment(Request $request){
	$quote = Quote::find($request->get('quote_id'));
	$payment_method_nonce = $request->get('payment_method_nonce');
	$result = \Braintree_Transaction::sale([
		'amount' => $quote->totalCost(),
		'options' => [ 'submitForSettlement' => True ],
		'paymentMethodNonce' => $payment_method_nonce 
	]);

	if( !empty($result->transaction) ) {
		$payment = new Payment();
		$payment->user_id = Auth::id();
		$payment->quote_id = $request->get('quote_id');
		$payment->job_id = $quote->job()->id;
		$payment->transaction = $result->transaction->id;
		$payment->save();

		$jobStatus = new JobStatus();
		$jobStatus->job_id = $quote->job()->id;
		$jobStatus->payment_id = $payment->id;
		$jobStatus->status_message = "Job Payed";
		$jobStatus->save();

		return("payment_made");
	}
	return ("payment_failed");
}
{%endhighlight%}