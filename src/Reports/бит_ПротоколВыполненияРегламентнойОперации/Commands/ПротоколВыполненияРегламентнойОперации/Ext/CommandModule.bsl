﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Отчет.бит_ПротоколВыполненияРегламентнойОперации.Форма"
				,Новый Структура("Документ, ПоказыватьДокумент", ПараметрКоманды, Ложь)
				,ПараметрыВыполненияКоманды.Источник
				,ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор
				,ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти