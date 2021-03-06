
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("Отбор",Новый Структура("ID",ПолучитьИД(ПараметрКоманды)));
	ОткрытьФорму("РегистрСведений.рс_ДокументыПоID.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

&НаСервере
Функция ПолучитьИД (Док)
	Если ТипЗнч(Док) = Тип ("ДокументСсылка.рс_АккруалПоID") Тогда
		Возврат Док.ID;
	ИначеЕсли ТипЗнч(Док) = Тип ("ДокументСсылка.рс_СторноЭУ") Тогда
		Если ТипЗнч(Док.ДокументОснование) = Тип ("ДокументСсылка.рс_АккруалПоID") Тогда
			Возврат Док.ДокументОснование.ID;	
		Иначе
			Возврат Док.ID;
		КонецЕсли;	
	ИначеЕсли ТипЗнч(Док) = Тип ("ДокументСсылка.рс_ЗаявкаНаДоговор") Тогда
		Возврат Док.ID;
	Иначе
		Запрос = Новый Запрос;
	КонецЕсли;	
КонецФункции	
