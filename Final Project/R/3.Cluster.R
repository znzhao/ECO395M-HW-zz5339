hmda_lar <- read.csv("E:/Homework/DataMining/ECO395M-HW-zz5339/Final Project/Data/hmda_lar.csv")
# district data
district = subset(hmda_lar,select = c(tract_to_msamd_income, population, minority_population, number_of_owner_occupied_units, number_of_1_to_4_family_units))
X.district = district
# loan data
loan =  subset(hmda_lar,select = c(loan_amount_000s,rate_spread, preapproval_name, loan_type_name, loan_purpose_name, lien_status_name, hoepa_status_name))
X.loan = model.matrix( ~ .-1,loan)[,-3]
# demographic data
demographic =  subset(hmda_lar,select = c(applicant_sex_name, applicant_ethnicity_name, applicant_race_name_1, applicant_race_name_2, applicant_race_name_3, applicant_race_name_4, applicant_race_name_5, applicant_income_000s, co_applicant_sex_name, co_applicant_ethnicity_name, co_applicant_race_name_1, co_applicant_race_name_2, co_applicant_race_name_3, co_applicant_race_name_4, co_applicant_race_name_5))
X.demographic = model.matrix( ~ .-1,demographic)[,-1]
# property data
property = subset(hmda_lar,select = c(property_type_name, owner_occupancy_name))
X.property = model.matrix( ~ .-1,property)[,-1]
# action data
action = subset(hmda_lar,select = c(action_taken_name, denial_reason_name_1, denial_reason_name_2, denial_reason_name_3, owner_occupancy_name))

X = cbind(X.demographic,X.loan)
