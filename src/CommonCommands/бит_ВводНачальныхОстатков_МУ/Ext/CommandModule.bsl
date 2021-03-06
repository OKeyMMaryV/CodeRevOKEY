
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("РегистрБухгалтерии", ПолучитьОбъектДоступаРегистрМСФО());
	
	ОткрытьФорму("Обработка.бит_ВводНачальныхОстатков.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьОбъектДоступаРегистрМСФО()
	
	МетаРегистрМСФО   = Метаданные.РегистрыБухгалтерии.бит_Дополнительный_2;
	ОбъектРегистрМСФО = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаРегистрМСФО);
	
	Возврат ОбъектРегистрМСФО;
	
КонецФункции

#КонецОбласти
