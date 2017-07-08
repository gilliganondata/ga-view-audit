# Google Analytics View Auditor

This is a script intended to help the user get a handle on his/her custom dimensions, custom metrics, and goals across one or many Google Analytics views:

* Which custom dimensions, custom metrics, and goals exist, but are not recording any data, or are recording very little data?
* Are there naming inconsistencies in the values populating the custom dimensions?

While custom metrics and goals are relatively easy to eyeball within the Google Analytics web interface, if you have a lot of custom dimensions, to truly assess them, you need to build one custom report for each custom dimension.

And, for all three of these, looking at more than a handful of views can get pretty time-consuming.

This script cycles through all of the views in a user-provided list of view IDs and returns three things for each view:

* A list of all of the active **custom dimensions** in the view, including the top 5 values based on **hits**
* A list of all of the active **custom metrics** in the view and the total for each metric
* A list of all of the active **goals** in the view and the number of conversions for the goal

The output is an Excel file:

* A worksheet that lists all of the views included in the assessment
* A worksheet that lists _all_ of the values checked -- custom dimensions, custom metrics, and goals across all views
* A worksheet for _each_ included view that lists just the custom dimensions, custom metrics, and goals for that view

## How to Use

This does take a little bit of setup work.

### Set Up a Google Project

This script uses [googleAnalyticsR](http://code.markedmondson.me/googleAnalyticsR/), and it hits the Google APIs pretty hard and fast, so you do _not_ want to use the default project. Luckily, it's pretty easy (and free) to set up a Google Project to work with googleAnalyticsR. Donal Phipps has put together a [nice video](http://donalphipps.co.uk/2017/06/25/setting-your-own-credentials-in-googleanalyticsr/) on how to do that.

### Put the Credentials in Your .Renviron File

If you put your client ID and client secret in a `.Renviron` file as `GA_CLIENT_ID` AND `GA_CLIENT_SECRET`, then you are all set (remember to restart your R session if you do add them after you're already working with this project).

The following lines in the code will then read those values in. But, you can also just hardcode the values if you like to live on the wild side:

```
ga_client_id <- Sys.getenv("GA_CLIENT_ID")
ga_client_secret <- Sys.getenv("GA_CLIENT_SECRET")
```

### Create a key_views.csv File

This is the list of views that you want to assess. You can get these from the [Google Analytics Query Explorer](https://ga-dev-tools.appspot.com/query-explorer/) or through any other means. But, ultimately, they need to go into a file called `key_views.csv` **located in the `input` folder**. (There is a file there now that you can use as a template.)

**KEY**: The headings for the file need to be `view_id` and `label`. `label` actually never appears in the output and is just there for your own reference as you are building the `.csv` file.

```
view_id,label
104######,Some Descriptor for Your Reference
119######,Some descriptor for your reference
```

If you're building it in Excel, it would look more like this before you exported it as a `.csv`:

| view_id | label |
|:---------|:---------|
| 104######   |  Some Descriptor for Your Reference  |
| 119######   |  Some descriptor for your reference  |

### Check/Adjust the Date Range

The script, by default, will pull data for the last 30 days. But, you can adjust this code as you see fit if you want a different timeframe:

```
end_date <- Sys.Date() - 1
start_date <- end_date - 29
```

### Set How Many Custom Dimension Values to Return

The script, by default, returns the top 5 custom dimension values by hits. This can be set to any number (if there are fewer than that number for any specific dimension, it will simply return all of the values). Just update this line of the code:

```
custom_dim_top_x <- 5
```

### Run the Script!

Open and run `ga-views-dims-metrics-goals.Rmd'. Depending on how many views and how many custom dimensions, custom metrics, and goals are set up, it may take a while to run. But, ultimately, it will export a file called `custom_data_summary.xlsx` to the `output` directory.

## A Note on the Output File

The **data_snapshot** column that appears on every sheet except the first one is probably the most important piece of output. It's three different things depending on the type of data:

* For **custom dimensions**, it's the top X (default = 5) values for the custom dimension based on hits, as well as, parenthethically, the actual number of hits
* For **custom metrics**, it's the total for the metric
* For **goals**, it's the number of conversions for the goal

That's about it! 
