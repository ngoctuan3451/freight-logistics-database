// =====================================================================
//  BigRig Movers (BRM) — MongoDB document model
//  The same customer data modelled as nested documents (customer profile
//  + embedded quotes array), then queried and updated.
//  Run in the MongoDB shell or the VS Code MongoDB extension.
// =====================================================================

use("bigrig_movers");

// --- Build the collection -------------------------------------------
db.customers.drop();

db.customers.insertMany([
  { _id: 1, customer_name: "Alice Tran", customer_business: "FreshBox",
    customer_address: "55 Lonsdale Street, Melbourne, 3000", customer_phone: "0400111222",
    customer_stats: { number_of_quotes: 2, number_of_jobs: 2, total_paid_jobcost: "$1,200.00", total_unpaid_jobcost: "-" },
    quotes: [
      { quote_no: 1, prepared_on: "02-May-2026", start_location: "Melbourne VIC", end_location: "Geelong VIC",  quote_cost: "$1,200.00", assigned_to_job: "Y" },
      { quote_no: 2, prepared_on: "05-May-2026", start_location: "Melbourne VIC", end_location: "Ballarat VIC", quote_cost: "$1,800.00", assigned_to_job: "Y" }
    ] },
  { _id: 2, customer_name: "Ben Carter", customer_business: "-",
    customer_address: "15 George Street, Sydney, 2000", customer_phone: "0400333444",
    customer_stats: { number_of_quotes: 1, number_of_jobs: 0, total_paid_jobcost: "-", total_unpaid_jobcost: "-" },
    quotes: [
      { quote_no: 3, prepared_on: "08-May-2026", start_location: "Sydney NSW", end_location: "Newcastle NSW", quote_cost: "$900.00", assigned_to_job: "N" }
    ] },
  { _id: 3, customer_name: "Chloe Smith", customer_business: "Smith Co",
    customer_address: "88 Queen Street, Brisbane, 4000", customer_phone: "0400555666",
    customer_stats: { number_of_quotes: 2, number_of_jobs: 1, total_paid_jobcost: "-", total_unpaid_jobcost: "$3,300.00" },
    quotes: [
      { quote_no: 4, prepared_on: "11-May-2026", start_location: "Brisbane QLD", end_location: "Sydney NSW", quote_cost: "$3,200.00", assigned_to_job: "Y" },
      { quote_no: 5, prepared_on: "14-May-2026", start_location: "Brisbane QLD", end_location: "Cairns QLD", quote_cost: "$2,800.00", assigned_to_job: "Y" }
    ] }
]);

// List everything just added
db.customers.find();

// --- Query: repeat customers based in Melbourne ----------------------
// More than one quote (nested field, dot notation) AND a Melbourne address (regex).
db.customers.find(
  { "customer_stats.number_of_quotes": { $gt: 1 }, customer_address: /Melbourne/ },
  { customer_name: 1, customer_address: 1, customer_phone: 1, customer_stats: 1 }   // projection
);

// --- Insert a new customer ------------------------------------------
db.customers.insertOne({
  _id: 7, customer_name: "Grace Hall", customer_business: "-",
  customer_address: "120 Hay Street, Perth, 6000", customer_phone: "0400343434",
  customer_stats: { number_of_quotes: 0, number_of_jobs: 0, total_paid_jobcost: "-", total_unpaid_jobcost: "-" },
  quotes: []
});

// --- Add a quote to that customer and refresh their stats -----------
db.customers.updateOne(
  { _id: 7 },
  {
    $push: { quotes: { quote_no: 9, prepared_on: "24-May-2026", start_location: "Perth WA", end_location: "Bunbury WA", quote_cost: "$1,500.00", assigned_to_job: "Y" } },
    $set:  { customer_stats: { number_of_quotes: 1, number_of_jobs: 1, total_paid_jobcost: "$1,500.00", total_unpaid_jobcost: "-" } }
  }
);

db.customers.find({ _id: 7 });
