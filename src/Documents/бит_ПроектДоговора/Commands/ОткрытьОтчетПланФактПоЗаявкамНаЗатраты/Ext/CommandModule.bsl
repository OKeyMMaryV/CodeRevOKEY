
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	мДоговорКонтрагента = бит_ДоговораСервер.НайтиДоговорКонтрагентаПоПроектуДоговора(ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючВарианта", "Основной");
	
	ФормаОтчета = ПолучитьФорму("Отчет.бит_ПланФактПоЗаявкамНаЗатраты.Форма", ПараметрыФормы,ПараметрыВыполненияКоманды.Источник
				,ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор
				,ПараметрыВыполненияКоманды.Окно);
	
	КомпоновщикНастроек   = ФормаОтчета.Отчет.КомпоновщикНастроек;
	НастройкиКомпоновщика = ПолучитьНастройкиКомпоновщика(КомпоновщикНастроек);
	
	НастройкиКомпоновщика.Отбор.Элементы.Очистить();
	
	ЭлементОтбора = НастройкиКомпоновщика.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ДоговорКонтрагента");
	ЭлементОтбора.ПравоеЗначение 	= мДоговорКонтрагента;
	ЭлементОтбора.Использование 	= Истина;
	ЭлементОтбора.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;
	
	ФормаОтчета.Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновщика);
	
	ФормаОтчета.СкомпоноватьРезультат();
	
	ФормаОтчета.Открыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьНастройкиКомпоновщика(КомпоновщикНастроек)
	
	Возврат КомпоновщикНастроек.ПолучитьНастройки();
	
КонецФункции

#КонецОбласти


