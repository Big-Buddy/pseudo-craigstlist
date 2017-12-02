Select  
		Results.UserID,
        Results.Email,
        Results.numAds,
        if(Results.sumServicePayments is null, 0, Results.sumServicePayments) sumServicePayments,
        if(Results.sumAdPrices is null, 0, Results.sumAdPrices) sumAdPrices,        
		if(Results.sumAdPrices is null, 0, Results.sumAdPrices) - if(Results.sumServicePayments is null, 0, Results.sumServicePayments) profitability 
	from ( 
		Select 
				Users.UserID,
				Users.Email,
                count(distinct Ads.AdID) numAds,
				if(
					DAYOFWEEK(RentedSpaces.DateRented) = 7 or DAYOFWEEK(RentedSpaces.DateRented) = 1, 
					sum(RentedSpaces.HoursRented*15 + if (RentedSpaces.DeliveryServices = 1, RentedSpaces.HoursRented*10, 0)), 
					sum(RentedSpaces.HoursRented*10 + if (RentedSpaces.DeliveryServices = 1, RentedSpaces.HoursRented*5, 0))
				) as sumServicePayments, 
				sum(Ads.PriceInCADCents) as sumAdPrices 
			from Users
			inner join Ads on Ads.PostingUserID = Users.UserID
            left join RentedSpaces on RentedSpaces.AdID = Ads.AdID
            where Users.UserType = 'Regular'
            and Ads.AdType = 'Sell'
			group by Ads.PostingUserID
	) Results