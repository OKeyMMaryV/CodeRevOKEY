﻿
#Область ОбработчикиСобытий
	
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДополнительныеОтчетыИОбработкиКлиент.ОткрытьФормуКомандДополнительныхОтчетовИОбработок(
			ПараметрКоманды,
			ПараметрыВыполненияКоманды,
			ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительныйОтчет(),
			"бит_КомИнт_УправлениеДоговорамиЗатратами");
			
КонецПроцедуры

#КонецОбласти
