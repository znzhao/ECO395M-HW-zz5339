
###############################################################

hmda_lar <- read.csv("E:/Homework/DataMining/ECO395M-HW-zz5339/Final Project/Data/hmda_lar.csv")
hmda_lar$ID <- c(1:nrow(hmda_lar))
# district data
X.district = subset(hmda_lar,select = c(tract_to_msamd_income, population, minority_population, number_of_owner_occupied_units, number_of_1_to_4_family_units))
# loan data
X.loan =  subset(hmda_lar,select = c(loan_amount_000s,rate_spread, preapproval_name, loan_type_name, loan_purpose_name, lien_status_name, hoepa_status_name))
# demographic data
X.demographic =  subset(hmda_lar,select = c(applicant_sex_name, applicant_ethnicity_name, applicant_race_name_1, applicant_race_name_2, applicant_race_name_3, applicant_income_000s, co_applicant_sex_name, co_applicant_ethnicity_name, co_applicant_race_name_1, co_applicant_race_name_2, co_applicant_race_name_3))
# property data
X.property = subset(hmda_lar,select = c(property_type_name, owner_occupancy_name))
# action data
X.action = subset(hmda_lar,select = c(action_taken_name, denial_reason_name_1, denial_reason_name_2, denial_reason_name_3, owner_occupancy_name))

###############################################################

# set the independent variables
X.data = cbind(X.demographic, X.loan, X.district, X.property)

###############################################################

# get the number metrix
X = subset(hmda_lar,select = ID)
for (x in colnames(X.data)){
  if (grepl("name", x)){
    temp = model.matrix(as.formula(paste("~", x, "-1")), X.data)[,-1]
    X = cbind(X,temp)
  }
  else{
    X = cbind(X,X.data[x])
  }
}

