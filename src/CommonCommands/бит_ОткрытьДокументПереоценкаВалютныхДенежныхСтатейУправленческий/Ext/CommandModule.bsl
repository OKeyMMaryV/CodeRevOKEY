
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
    
    ОткрытьФорму("Документ.бит_ПереоценкаВалютныхДенежныхСтатей.ФормаСписка"
				, , ПараметрыВыполненияКоманды.Источник
				, Новый УникальныйИдентификатор("1cd001b0-465c-4690-a89c-3beda82350f9")//ПараметрыВыполненияКоманды.Уникальность
				, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти
