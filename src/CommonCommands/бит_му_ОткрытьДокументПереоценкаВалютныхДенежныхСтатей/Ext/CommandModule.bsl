
#Область ОбработчикиСобытий 	

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
    
    ПараметрыФормы = Новый Структура("ОбъектСистемы", ПолучитьОбъектДоступаРегистрМСФО());
    
    ОткрытьФорму("Документ.бит_ПереоценкаВалютныхДенежныхСтатей.ФормаСписка"
				, ПараметрыФормы, ПараметрыВыполненияКоманды.Источник
				, Новый УникальныйИдентификатор("1cd001b2-465c-4690-a89c-3beda82350f9")//ПараметрыВыполненияКоманды.Уникальность
				, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьОбъектДоступаРегистрМСФО()
	
	МетаРегистрМСФО = Метаданные.РегистрыБухгалтерии.бит_Дополнительный_2;
	ОбъектРегистрМСФО = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаРегистрМСФО);
	
	Возврат ОбъектРегистрМСФО;
	
КонецФункции // ПолучитьОбъектДоступаРегистрМСФО()

#КонецОбласти
