﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИнтеграцияВЕТИСКлиент.ОткрытьПротоколОбменаВЕТИС(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

#КонецОбласти