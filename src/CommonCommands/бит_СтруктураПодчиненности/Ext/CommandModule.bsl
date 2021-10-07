﻿
#Область ОбработчикиСобытий

// бит_DKravchenko Процедура - обработчик команды.
// 
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.бит_ФормаСтруктурыПодчиненностиУправляемая"
				,Новый Структура("ДокументСсылка", ПараметрКоманды)
				,ПараметрыВыполненияКоманды.Источник
				,ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор
				,ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти 	
