********************************************************************
* MSDS 6372-401
* Project 1
* T Deason, J Lancon, J Vasquez
*
* Ask a home buyer to describe their dream house, and they probably won't
* begin with the height of the basement ceiling or the proximity to an
* east-west railroad. But this Kaggle competition's dataset proves that
* much more influences price negotiations than the number of bedrooms or a
* white-picket fence.
* With 79 explanatory variables describing (almost) every aspect of residential
* homes in Ames, Iowa, this competition challenges you to predict the final
* price of each home.
* Data and Description: 
* https://www.kaggle.com/c/house-prices-advanced-regression-techniques

* ANALYSIS: Build the most predictive model for sales prices of homes in
* all of Ames Iowa.  The group is limited to only the techniques we have
* learned in 6371 & up to Unit 6 in 6372 (no random forests or other methods
* we have not yet covered.) CI for parameters are not required. However,
* you should provide evidence as to why you chose your final model. A Cross
* Validation is manditory as is comparing at least the adjusted R2 and AIC 
* between competing models.  Provide the top 3 models (ranked in order) based
* on your ASE from the test set as well as the top 3 models with respect to
* Kaggle score. (Note: At least one of the three models must be the results
* of some from of a regularized method (LASSO, RIDGE, ElasticNet, Adaptive LASSO,
* etc,))   
*********************************************************************;


FILENAME REFFILE '/home/jlancon0/my_courses/MSDS 6372/Project 1/train_clean.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.MLSData;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.MLSData; RUN;

run;

Data MLSData2;
set MLSData;

* Applying Logrithmic transformation to specific variables;
LogSalePrice = Log(SalePrice);
LogGrLivArea = Log(GrLivArea);
LogLotArea = Log(LotArea);
Logx1stFlrSF = Log(x1stFlrSF);

if BsmtUnfSF = 0 then BsmtUnfSF = 1;
LogBsmtUnfSF = Log(BsmtUnfSF);
if BsmtFinSF1 = 0 then BsmtFinSF1 = 1;
LogBsmtFinSF1 = Log(BsmtFinSF1);
if TotalBsmtSF = 0 then TotalBsmtSF = 1;
LogTotalBsmtSF = Log(TotalBsmtSF);
if x2ndFlrSF = 0 then x2ndFlrSF = 1;
Logx2ndFlrSF = Log(x2ndFlrSF);
if GarageArea = 0 then GarageArea = 1;
LogGarageArea = Log(GarageArea);
if WoodDeckSF = 0 then WoodDeckSF = 1;
LogWoodDeckSF = Log(WoodDeckSF);
if OpenPorchSF = 0 then OpenPorchSF = 1;
LogOpenPorchSF = Log(OpenPorchSF);


* KitchenQual = NA Ex is base case;
* Changing type of variable;
	if KitchenQual_GD = "TRUE" then KitchenQual_GD = 1; else KitchenQual_GD = 0;  
	if KitchenQual_TA = "TRUE" then KitchenQual_TA = 1; else KitchenQual_TA = 0; 
	if KitchenQual_Fa = "TRUE" then KitchenQual_Fa = 1; else KitchenQual_Fa = 0; 
	if KitchenQual_Ex = "TRUE" then KitchenQual_Ex = 1; else KitchenQual_Ex = 0; 
KitchenQual_GDNum = KitchenQual_GD*1;
KitchenQual_TANum = KitchenQual_TA*1;
KitchenQual_FaNum = KitchenQual_Fa*1;
Drop KitchenQual_GD;
Drop KitchenQual_TA;
Drop KitchenQual_Fa;
rename KitchenQual_GDNum=KitchenQual_GD;
rename KitchenQual_TANum=KitchenQual_TA;
rename KitchenQual_FaNum=KitchenQual_Fa;



* BldgType 1Fam is base case;
	if BldgType_Twnhs = "TRUE" then BldgType_Twnhs = 1; else BldgType_Twnhs = 0; 
	if BldgType_2fmCon = "TRUE" then BldgType_2fmCon = 1; else BldgType_2fmCon = 0; 
	if BldgType_Duplex = "TRUE" then BldgType_Duplex = 1; else BldgType_Duplex = 0; 
	if BldgType_TwnHsE = "TRUE" then BldgType_TwnHsE = 1; else BldgType_TwnHsE = 0;
	if BldgType_1Fam = "TRUE" then BldgType_1Fam = 1; else BldgType_1Fam = 0;
BldgType_TwnhsNum = BldgType_Twnhs*1;
BldgType_2fmConNum = BldgType_2fmCon*1;
BldgType_DuplexNum = BldgType_Duplex*1;
BldgType_TwnHsENum = BldgType_TwnHsE*1;
Drop BldgType_Twnhs;
Drop BldgType_2fmCon;
Drop BldgType_Duplex;
Drop BldgType_TwnHsE;
rename BldgType_TwnhsNum = BldgType_Twnhs;
rename BldgType_2fmConNum = BldgType_2fmCon;
rename BldgType_DuplexNum = BldgType_Duplex;
rename BldgType_TwnHsENum = BldgType_TwnHsE;

	
* Neighborhood Catagorical variable;
* Base Case Neighborhoods BrDale;
	if Neighborhood_Edwards = "TRUE" then Neighborhood_Edwards = 1; else Neighborhood_Edwards = 0; 
	if Neighborhood_IDOTRR = "TRUE" then Neighborhood_IDOTRR = 1; else Neighborhood_IDOTRR = 0;
	if Neighborhood_Meadow = "TRUE" then Neighborhood_Meadow = 1; else Neighborhood_Meadow = 0;
	if Neighborhood_OldTown = "TRUE" then Neighborhood_OldTown = 1; else Neighborhood_OldTown = 0;
	if Neighborhood_Blueste = "TRUE" then Neighborhood_Blueste = 1; else Neighborhood_Blueste = 0;
	if Neighborhood_BrkSide = "TRUE" then Neighborhood_BrkSide = 1; else Neighborhood_BrkSide = 0;
	if Neighborhood_Mitchel = "TRUE" then Neighborhood_Mitchel = 1; else Neighborhood_Mitchel = 0;
	if Neighborhood_NAmes = "TRUE" then Neighborhood_NAmes = 1; else Neighborhood_NAmes = 0;
	if Neighborhood_NPkVill = "TRUE" then Neighborhood_NPkVill = 1; else Neighborhood_NPkVill = 0;
	if Neighborhood_Sawyer = "TRUE" then Neighborhood_Sawyer = 1; else Neighborhood_Sawyer = 0;
	if Neighborhood_SWISU = "TRUE" then Neighborhood_SWISU = 1; else Neighborhood_SWISU = 0;
	if Neighborhood_Blmngtn = "TRUE" then Neighborhood_Blmngtn = 1; else Neighborhood_Blmngtn = 0;
	if Neighborhood_ClearCr = "TRUE" then Neighborhood_ClearCr = 1; else Neighborhood_ClearCr = 0;
	if Neighborhood_CollgCr = "TRUE" then Neighborhood_CollgCr = 1; else Neighborhood_CollgCr = 0;
	if Neighborhood_Crawfor = "TRUE" then Neighborhood_Crawfor = 1; else Neighborhood_Crawfor = 0;
	if Neighborhood_Gilbert = "TRUE" then Neighborhood_Gilbert = 1; else Neighborhood_Gilbert = 0;
	if Neighborhood_NWAmes = "TRUE" then Neighborhood_NWAmes = 1; else Neighborhood_NWAmes = 0;
	if Neighborhood_SawyerW = "TRUE" then Neighborhood_SawyerW = 1; else Neighborhood_SawyerW = 0;
	if Neighborhood_Somerst = "TRUE" then Neighborhood_Somerst = 1; else Neighborhood_Somerst = 0;
	if Neighborhood_Timber = "TRUE" then Neighborhood_Timber = 1; else Neighborhood_Timber = 0;
	if Neighborhood_Veenker = "TRUE" then Neighborhood_Veenker = 1; else Neighborhood_Veenker = 0;
	if Neighborhood_NoRidge = "TRUE" then Neighborhood_NoRidge = 1; else Neighborhood_NoRidge = 0;
	if Neighborhood_NridgHt = "TRUE" then Neighborhood_NridgHt = 1; else Neighborhood_NridgHt = 0;
	if Neighborhood_StoneBr = "TRUE" then Neighborhood_StoneBr = 1; else Neighborhood_StoneBr = 0;
	if Neighborhood_BrDale = "TRUE" then Neighborhood_BrDale = 1; else Neighborhood_BrDale = 0;
Neighborhood_EdwardsNum = Neighborhood_Edwards*1;
Neighborhood_IDOTRRNum = Neighborhood_IDOTRR*1;
Neighborhood_MeadowNum = Neighborhood_Meadow*1;
Neighborhood_OldTownNum = Neighborhood_OldTown*1;
Neighborhood_BluesteNum = Neighborhood_Blueste*1;
Neighborhood_BrkSideNum = Neighborhood_BrkSide*1;
Neighborhood_MitchelNum = Neighborhood_Mitchel*1;
Neighborhood_NAmesNum = Neighborhood_NAmes*1;
Neighborhood_NPkVillNum = Neighborhood_NPkVill*1;
Neighborhood_SawyerNum = Neighborhood_Sawyer*1;
Neighborhood_SWISUNum = Neighborhood_SWISU*1;
Neighborhood_BlmngtnNum = Neighborhood_Blmngtn*1;
Neighborhood_ClearCrNum = Neighborhood_ClearCr*1;
Neighborhood_CollgCrNum = Neighborhood_CollgCr*1;
Neighborhood_CrawforNum = Neighborhood_Crawfor*1;
Neighborhood_GilbertNum = Neighborhood_Gilbert*1;
Neighborhood_NWAmesNum = Neighborhood_NWAmes*1;
Neighborhood_SawyerWNum = Neighborhood_SawyerW*1;
Neighborhood_SomerstNum = Neighborhood_Somerst*1;
Neighborhood_TimberNum = Neighborhood_Timber*1;
Neighborhood_VeenkerNum = Neighborhood_Veenker*1;
Neighborhood_NoRidgeNum = Neighborhood_NoRidge*1;
Neighborhood_NridgHtNum = Neighborhood_NridgHt*1;
Neighborhood_StoneBrNum = Neighborhood_StoneBr*1;
Drop Neighborhood_Edwards;
Drop Neighborhood_IDOTRR;
Drop Neighborhood_Meadow;
Drop Neighborhood_OldTown;
Drop Neighborhood_Blueste;
Drop Neighborhood_BrkSide;
Drop Neighborhood_Mitchel;
Drop Neighborhood_NAmes;
Drop Neighborhood_NPkVill;
Drop Neighborhood_Sawyer;
Drop Neighborhood_SWISU;
Drop Neighborhood_Blmngtn;
Drop Neighborhood_ClearCr;
Drop Neighborhood_CollgCr;
Drop Neighborhood_Crawfor;
Drop Neighborhood_Gilbert;
Drop Neighborhood_NWAmes;
Drop Neighborhood_SawyerW;
Drop Neighborhood_Somerst;
Drop Neighborhood_Timber;
Drop Neighborhood_Veenker;
Drop Neighborhood_NoRidge;
Drop Neighborhood_NridgHt;
Drop Neighborhood_StoneBr;
rename Neighborhood_EdwardsNum = Neighborhood_Edwards;
rename Neighborhood_IDOTRRNum = Neighborhood_IDOTRR;
rename Neighborhood_MeadowNum = Neighborhood_Meadow;
rename Neighborhood_OldTownNum = Neighborhood_OldTown;
rename Neighborhood_BluesteNum = Neighborhood_Blueste;
rename Neighborhood_BrkSideNum = Neighborhood_BrkSide;
rename Neighborhood_MitchelNum = Neighborhood_Mitchel;
rename Neighborhood_NAmesNum = Neighborhood_NAmes;
rename Neighborhood_NPkVillNum = Neighborhood_NPkVill;
rename Neighborhood_SawyerNum = Neighborhood_Sawyer;
rename Neighborhood_SWISUNum = Neighborhood_SWISU;
rename Neighborhood_BlmngtnNum = Neighborhood_Blmngtn;
rename Neighborhood_ClearCrNum = Neighborhood_ClearCr;
rename Neighborhood_CollgCrNum = Neighborhood_CollgCr;
rename Neighborhood_CrawforNum = Neighborhood_Crawfor;
rename Neighborhood_GilbertNum = Neighborhood_Gilbert;
rename Neighborhood_NWAmesNum = Neighborhood_NWAmes;
rename Neighborhood_SawyerWNum = Neighborhood_SawyerW;
rename Neighborhood_SomerstNum = Neighborhood_Somerst;
rename Neighborhood_TimberNum = Neighborhood_Timber;
rename Neighborhood_VeenkerNum = Neighborhood_Veenker;
rename Neighborhood_NoRidgeNum = Neighborhood_NoRidge;
rename Neighborhood_NridgHtNum = Neighborhood_NridgHt;
rename Neighborhood_StoneBrNum = Neighborhood_StoneBr;


* HouseStyle Catagorical variable;
* Base Case HouseStyle 1Story;
	if 'HouseStyle_1.5Fin'n = "TRUE" then HouseStyle_15Fin = 1; else HouseStyle_15Fin = 0;
	if 'HouseStyle_1.5Unf'n = "TRUE" then HouseStyle_15Unf = 1; else HouseStyle_15Unf = 0;
	if 'HouseStyle_2.5Unf'n = "TRUE" then HouseStyle_25Unf = 1; else HouseStyle_25Unf = 0;
	if HouseStyle_2Story = "TRUE" then HouseStyle_2Story = 1; else HouseStyle_2Story = 0;
	if HouseStyle_SFoyer = "TRUE" then HouseStyle_SFoyer = 1; else HouseStyle_SFoyer = 0;
	if HouseStyle_SLvl = "TRUE" then HouseStyle_SLvl = 1; else HouseStyle_SLvl = 0; 
HouseStyle_15FinNum = HouseStyle_15Fin*1;
HouseStyle_15UnfNum = HouseStyle_15Unf*1;
HouseStyle_25UnfNum = HouseStyle_25Unf*1;
HouseStyle_2StoryNum = HouseStyle_2Story*1;
HouseStyle_SFoyerNum = HouseStyle_SFoyer*1;
HouseStyle_SLvlNum = HouseStyle_SLvl*1;
Drop HouseStyle_15Fin;
Drop HouseStyle_15Unf;
Drop HouseStyle_25Unf;
Drop HouseStyle_2Story;
Drop HouseStyle_SFoyer;
Drop HouseStyle_SLvl;
rename HouseStyle_15FinNum = HouseStyle_15Fin;
rename HouseStyle_15UnfNum = HouseStyle_15Unf;
rename HouseStyle_25UnfNum = HouseStyle_25Unf;
rename HouseStyle_2StoryNum = HouseStyle_2Story;
rename HouseStyle_SFoyerNum = HouseStyle_SFoyer;
rename HouseStyle_SLvlNum = HouseStyle_SLvl;

;
Run;

** Matrix Scatter Plot - Information Only***;
proc sgscatter data=MLSData2;
matrix LogSalePrice GrLivArea LogGrLivArea;
Run;
                                                                                                                                                                                                
proc glmselect data=MLSData2                                                                                                                                                                                            
seed=1 plots(stepAxis=number)=(criterionPanel ASEPlot CRITERIONPANEL) plots=all;                                                                                                                              
*class MSZoning LotConfig LandSlope Condition1 Condition2;
model LogSalePrice = GrLivArea LogGrLivArea LotFrontage LotArea LogLotArea x1stFlrSF Logx1stFlrSF BsmtUnfSF LogBsmtUnfSF BsmtFinSF1 LogBsmtFinSF1 TotalBsmtSF LogTotalBsmtSF x2ndFlrSF Logx2ndFlrSF GarageArea LogGarageArea WoodDeckSF LogWoodDeckSF OpenPorchSF LogOpenPorchSF OverallQual OverallCond YearBuilt YearRemodAdd MasVnrArea LowQualFinSF BsmtFullBath BsmtHalfBath FullBath HalfBath BedRoomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageCars PoolArea EnclosedPorch ScreenPorch GarageYrBlt Miscval MoSold YrSold BsmtFinSF2
KitchenQual_GD KitchenQual_TA KitchenQual_Fa BldgType_Twnhs BldgType_2fmCon BldgType_Duplex BldgType_TwnHsE 
Neighborhood_Edwards Neighborhood_IDOTRR Neighborhood_Meadow Neighborhood_OldTown Neighborhood_Blueste Neighborhood_BrkSide Neighborhood_Mitchel Neighborhood_NAmes Neighborhood_NPkVill Neighborhood_Sawyer Neighborhood_SWISU Neighborhood_Blmngtn Neighborhood_ClearCr Neighborhood_CollgCr Neighborhood_Crawfor Neighborhood_Gilbert Neighborhood_NWAmes Neighborhood_SawyerW Neighborhood_Somerst Neighborhood_Timber Neighborhood_Veenker Neighborhood_NoRidge Neighborhood_NridgHt Neighborhood_StoneBr
HouseStyle_15Fin HouseStyle_15Unf HouseStyle_25Unf HouseStyle_2Story HouseStyle_SFoyer HouseStyle_SLvl/
selection=stepwise(choose=CV stop=CV) cvmethod=split(10) CVdetails;
Run;  

************************************************
* Proc Reg and Glm - Selection Model;
************************************************;
proc reg data=MLSData2 plots=all;
	class MSZoning LotConfig LandSlope Condition1 Condition2 HouseStyle;
	model LogSalePrice = /VIF r cli;
title 'Model Regression For LASSO (no Catagorical)';
run;

proc glm data=MLSData2 plots=all;
class MSZoning LotConfig LandSlope Condition1 Condition2 HouseStyle;
model LogSalePrice = LogGrLivArea100 OverallQual OverallCond LogLotArea bbmnnss bcccgnsstv nns BldgDV3 YearBuilt YearRemodAdd BsmtFullBath Fireplaces GarageCars TotalBsmtSF100 BsmtFinSF1_100/ cli; 





****************************************************************************
**** Kaggle Analysis Code
****************************************************************************
/* This code assumes that the training and test sets have been imported.  They have been called “train” and “test” respectively … the final data set we would like you to export and submit to Kaggle is called results2 … Whamo! 
At this point the train and test sets have been preprocessed so that there is no cleaning or manipulation of the data done with SAS code here.  */
;

FILENAME REFFILE '/home/jlancon0/my_courses/MSDS 6372/Project 1/test_clean.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.TestCleaned;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.TestCleaned; RUN;

Data test;
set TestCleaned;
SalePrice = .;

* Applying Logrithmic transformation to specific variables;
LogSalePrice = Log(SalePrice);
LogGrLivArea = Log(GrLivArea);
LogLotArea = Log(LotArea);
Logx1stFlrSF = Log(x1stFlrSF);

if BsmtUnfSF = 0 then BsmtUnfSF = 1;
LogBsmtUnfSF = Log(BsmtUnfSF);
if BsmtFinSF1 = 0 then BsmtFinSF1 = 1;
LogBsmtFinSF1 = Log(BsmtFinSF1);
if TotalBsmtSF = 0 then TotalBsmtSF = 1;
LogTotalBsmtSF = Log(TotalBsmtSF);
if x2ndFlrSF = 0 then x2ndFlrSF = 1;
Logx2ndFlrSF = Log(x2ndFlrSF);
if GarageArea = 0 then GarageArea = 1;
LogGarageArea = Log(GarageArea);
if WoodDeckSF = 0 then WoodDeckSF = 1;
LogWoodDeckSF = Log(WoodDeckSF);
if OpenPorchSF = 0 then OpenPorchSF = 1;
LogOpenPorchSF = Log(OpenPorchSF);


* KitchenQual = NA Ex is base case;
* Changing type of variable;
	if KitchenQual_GD = "TRUE" then KitchenQual_GD = 1; else KitchenQual_GD = 0;  
	if KitchenQual_TA = "TRUE" then KitchenQual_TA = 1; else KitchenQual_TA = 0; 
	if KitchenQual_Fa = "TRUE" then KitchenQual_Fa = 1; else KitchenQual_Fa = 0; 
	if KitchenQual_Ex = "TRUE" then KitchenQual_Ex = 1; else KitchenQual_Ex = 0; 
KitchenQual_GDNum = KitchenQual_GD*1;
KitchenQual_TANum = KitchenQual_TA*1;
KitchenQual_FaNum = KitchenQual_Fa*1;
Drop KitchenQual_GD;
Drop KitchenQual_TA;
Drop KitchenQual_Fa;
rename KitchenQual_GDNum=KitchenQual_GD;
rename KitchenQual_TANum=KitchenQual_TA;
rename KitchenQual_FaNum=KitchenQual_Fa;



* BldgType 1Fam is base case;
	if BldgType_Twnhs = "TRUE" then BldgType_Twnhs = 1; else BldgType_Twnhs = 0; 
	if BldgType_2fmCon = "TRUE" then BldgType_2fmCon = 1; else BldgType_2fmCon = 0; 
	if BldgType_Duplex = "TRUE" then BldgType_Duplex = 1; else BldgType_Duplex = 0; 
	if BldgType_TwnHsE = "TRUE" then BldgType_TwnHsE = 1; else BldgType_TwnHsE = 0;
	if BldgType_1Fam = "TRUE" then BldgType_1Fam = 1; else BldgType_1Fam = 0;
BldgType_TwnhsNum = BldgType_Twnhs*1;
BldgType_2fmConNum = BldgType_2fmCon*1;
BldgType_DuplexNum = BldgType_Duplex*1;
BldgType_TwnHsENum = BldgType_TwnHsE*1;
Drop BldgType_Twnhs;
Drop BldgType_2fmCon;
Drop BldgType_Duplex;
Drop BldgType_TwnHsE;
rename BldgType_TwnhsNum = BldgType_Twnhs;
rename BldgType_2fmConNum = BldgType_2fmCon;
rename BldgType_DuplexNum = BldgType_Duplex;
rename BldgType_TwnHsENum = BldgType_TwnHsE;

	
* Neighborhood Catagorical variable;
* Base Case Neighborhoods BrDale;
	if Neighborhood_Edwards = "TRUE" then Neighborhood_Edwards = 1; else Neighborhood_Edwards = 0; 
	if Neighborhood_IDOTRR = "TRUE" then Neighborhood_IDOTRR = 1; else Neighborhood_IDOTRR = 0;
	if Neighborhood_Meadow = "TRUE" then Neighborhood_Meadow = 1; else Neighborhood_Meadow = 0;
	if Neighborhood_OldTown = "TRUE" then Neighborhood_OldTown = 1; else Neighborhood_OldTown = 0;
	if Neighborhood_Blueste = "TRUE" then Neighborhood_Blueste = 1; else Neighborhood_Blueste = 0;
	if Neighborhood_BrkSide = "TRUE" then Neighborhood_BrkSide = 1; else Neighborhood_BrkSide = 0;
	if Neighborhood_Mitchel = "TRUE" then Neighborhood_Mitchel = 1; else Neighborhood_Mitchel = 0;
	if Neighborhood_NAmes = "TRUE" then Neighborhood_NAmes = 1; else Neighborhood_NAmes = 0;
	if Neighborhood_NPkVill = "TRUE" then Neighborhood_NPkVill = 1; else Neighborhood_NPkVill = 0;
	if Neighborhood_Sawyer = "TRUE" then Neighborhood_Sawyer = 1; else Neighborhood_Sawyer = 0;
	if Neighborhood_SWISU = "TRUE" then Neighborhood_SWISU = 1; else Neighborhood_SWISU = 0;
	if Neighborhood_Blmngtn = "TRUE" then Neighborhood_Blmngtn = 1; else Neighborhood_Blmngtn = 0;
	if Neighborhood_ClearCr = "TRUE" then Neighborhood_ClearCr = 1; else Neighborhood_ClearCr = 0;
	if Neighborhood_CollgCr = "TRUE" then Neighborhood_CollgCr = 1; else Neighborhood_CollgCr = 0;
	if Neighborhood_Crawfor = "TRUE" then Neighborhood_Crawfor = 1; else Neighborhood_Crawfor = 0;
	if Neighborhood_Gilbert = "TRUE" then Neighborhood_Gilbert = 1; else Neighborhood_Gilbert = 0;
	if Neighborhood_NWAmes = "TRUE" then Neighborhood_NWAmes = 1; else Neighborhood_NWAmes = 0;
	if Neighborhood_SawyerW = "TRUE" then Neighborhood_SawyerW = 1; else Neighborhood_SawyerW = 0;
	if Neighborhood_Somerst = "TRUE" then Neighborhood_Somerst = 1; else Neighborhood_Somerst = 0;
	if Neighborhood_Timber = "TRUE" then Neighborhood_Timber = 1; else Neighborhood_Timber = 0;
	if Neighborhood_Veenker = "TRUE" then Neighborhood_Veenker = 1; else Neighborhood_Veenker = 0;
	if Neighborhood_NoRidge = "TRUE" then Neighborhood_NoRidge = 1; else Neighborhood_NoRidge = 0;
	if Neighborhood_NridgHt = "TRUE" then Neighborhood_NridgHt = 1; else Neighborhood_NridgHt = 0;
	if Neighborhood_StoneBr = "TRUE" then Neighborhood_StoneBr = 1; else Neighborhood_StoneBr = 0;
	if Neighborhood_BrDale = "TRUE" then Neighborhood_BrDale = 1; else Neighborhood_BrDale = 0;
Neighborhood_EdwardsNum = Neighborhood_Edwards*1;
Neighborhood_IDOTRRNum = Neighborhood_IDOTRR*1;
Neighborhood_MeadowNum = Neighborhood_Meadow*1;
Neighborhood_OldTownNum = Neighborhood_OldTown*1;
Neighborhood_BluesteNum = Neighborhood_Blueste*1;
Neighborhood_BrkSideNum = Neighborhood_BrkSide*1;
Neighborhood_MitchelNum = Neighborhood_Mitchel*1;
Neighborhood_NAmesNum = Neighborhood_NAmes*1;
Neighborhood_NPkVillNum = Neighborhood_NPkVill*1;
Neighborhood_SawyerNum = Neighborhood_Sawyer*1;
Neighborhood_SWISUNum = Neighborhood_SWISU*1;
Neighborhood_BlmngtnNum = Neighborhood_Blmngtn*1;
Neighborhood_ClearCrNum = Neighborhood_ClearCr*1;
Neighborhood_CollgCrNum = Neighborhood_CollgCr*1;
Neighborhood_CrawforNum = Neighborhood_Crawfor*1;
Neighborhood_GilbertNum = Neighborhood_Gilbert*1;
Neighborhood_NWAmesNum = Neighborhood_NWAmes*1;
Neighborhood_SawyerWNum = Neighborhood_SawyerW*1;
Neighborhood_SomerstNum = Neighborhood_Somerst*1;
Neighborhood_TimberNum = Neighborhood_Timber*1;
Neighborhood_VeenkerNum = Neighborhood_Veenker*1;
Neighborhood_NoRidgeNum = Neighborhood_NoRidge*1;
Neighborhood_NridgHtNum = Neighborhood_NridgHt*1;
Neighborhood_StoneBrNum = Neighborhood_StoneBr*1;
Drop Neighborhood_Edwards;
Drop Neighborhood_IDOTRR;
Drop Neighborhood_Meadow;
Drop Neighborhood_OldTown;
Drop Neighborhood_Blueste;
Drop Neighborhood_BrkSide;
Drop Neighborhood_Mitchel;
Drop Neighborhood_NAmes;
Drop Neighborhood_NPkVill;
Drop Neighborhood_Sawyer;
Drop Neighborhood_SWISU;
Drop Neighborhood_Blmngtn;
Drop Neighborhood_ClearCr;
Drop Neighborhood_CollgCr;
Drop Neighborhood_Crawfor;
Drop Neighborhood_Gilbert;
Drop Neighborhood_NWAmes;
Drop Neighborhood_SawyerW;
Drop Neighborhood_Somerst;
Drop Neighborhood_Timber;
Drop Neighborhood_Veenker;
Drop Neighborhood_NoRidge;
Drop Neighborhood_NridgHt;
Drop Neighborhood_StoneBr;
rename Neighborhood_EdwardsNum = Neighborhood_Edwards;
rename Neighborhood_IDOTRRNum = Neighborhood_IDOTRR;
rename Neighborhood_MeadowNum = Neighborhood_Meadow;
rename Neighborhood_OldTownNum = Neighborhood_OldTown;
rename Neighborhood_BluesteNum = Neighborhood_Blueste;
rename Neighborhood_BrkSideNum = Neighborhood_BrkSide;
rename Neighborhood_MitchelNum = Neighborhood_Mitchel;
rename Neighborhood_NAmesNum = Neighborhood_NAmes;
rename Neighborhood_NPkVillNum = Neighborhood_NPkVill;
rename Neighborhood_SawyerNum = Neighborhood_Sawyer;
rename Neighborhood_SWISUNum = Neighborhood_SWISU;
rename Neighborhood_BlmngtnNum = Neighborhood_Blmngtn;
rename Neighborhood_ClearCrNum = Neighborhood_ClearCr;
rename Neighborhood_CollgCrNum = Neighborhood_CollgCr;
rename Neighborhood_CrawforNum = Neighborhood_Crawfor;
rename Neighborhood_GilbertNum = Neighborhood_Gilbert;
rename Neighborhood_NWAmesNum = Neighborhood_NWAmes;
rename Neighborhood_SawyerWNum = Neighborhood_SawyerW;
rename Neighborhood_SomerstNum = Neighborhood_Somerst;
rename Neighborhood_TimberNum = Neighborhood_Timber;
rename Neighborhood_VeenkerNum = Neighborhood_Veenker;
rename Neighborhood_NoRidgeNum = Neighborhood_NoRidge;
rename Neighborhood_NridgHtNum = Neighborhood_NridgHt;
rename Neighborhood_StoneBrNum = Neighborhood_StoneBr;


* HouseStyle Catagorical variable;
* Base Case HouseStyle 1Story;
	if 'HouseStyle_1.5Fin'n = "TRUE" then HouseStyle_15Fin = 1; else HouseStyle_15Fin = 0;
	if 'HouseStyle_1.5Unf'n = "TRUE" then HouseStyle_15Unf = 1; else HouseStyle_15Unf = 0;
	if 'HouseStyle_2.5Unf'n = "TRUE" then HouseStyle_25Unf = 1; else HouseStyle_25Unf = 0;
	if HouseStyle_2Story = "TRUE" then HouseStyle_2Story = 1; else HouseStyle_2Story = 0;
	if HouseStyle_SFoyer = "TRUE" then HouseStyle_SFoyer = 1; else HouseStyle_SFoyer = 0;
	if HouseStyle_SLvl = "TRUE" then HouseStyle_SLvl = 1; else HouseStyle_SLvl = 0; 
HouseStyle_15FinNum = HouseStyle_15Fin*1;
HouseStyle_15UnfNum = HouseStyle_15Unf*1;
HouseStyle_25UnfNum = HouseStyle_25Unf*1;
HouseStyle_2StoryNum = HouseStyle_2Story*1;
HouseStyle_SFoyerNum = HouseStyle_SFoyer*1;
HouseStyle_SLvlNum = HouseStyle_SLvl*1;
Drop HouseStyle_15Fin;
Drop HouseStyle_15Unf;
Drop HouseStyle_25Unf;
Drop HouseStyle_2Story;
Drop HouseStyle_SFoyer;
Drop HouseStyle_SLvl;
rename HouseStyle_15FinNum = HouseStyle_15Fin;
rename HouseStyle_15UnfNum = HouseStyle_15Unf;
rename HouseStyle_25UnfNum = HouseStyle_25Unf;
rename HouseStyle_2StoryNum = HouseStyle_2Story;
rename HouseStyle_SFoyerNum = HouseStyle_SFoyer;
rename HouseStyle_SLvlNum = HouseStyle_SLvl;

;
Run;


Data train;
Set MLSData2;
Run;
******************************************************************;

*data test;
*set test;
*LogSalePrice = .;
;

data train2;
 set train test;
run;

proc glm data = train2;
*class MSZoning MSSubClass;
model LogSalePrice =  OverallQual LogGrLivArea YearBuilt LogLotArea OverallCond LogBsmtFinSF1 GarageCars Logx2ndFlrSF  Neighborhood_Crawfor Neighborhood_NridgHt BldgType_Duplex Neighborhood_StoneBr Neighborhood_Somerst Neighborhood_NoRidge bsmtfullbath / cli solution;
output out = results p = Predict;
run;


/* Can't have negative predictions because of RMLSE */
/* Also must have only two columns with appropriate labels. */

data results2;
set results;
if Predict > 0 then LogSalePrice = Predict;
if Predict < 0 then LogSalePrice = log(10000);
SalePrice = exp(LogSalePrice);
keep id SalePrice;
where id > 1460;
;
Run;