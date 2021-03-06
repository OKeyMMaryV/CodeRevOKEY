
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыВыполнения = ПараметрыВыполнения(ПараметрКоманды);
	Если ПараметрыВыполнения.Поддерживается Тогда
		ДанныеЗаполнения = Новый Структура; 
		ДанныеЗаполнения.Вставить("ДокОснование", ПараметрКоманды);
		ДанныеЗаполнения.Вставить("ВозвратЛимита", ПредопределенноеЗначение("Перечисление.бит_ВидыКорректировокКонтрольныхЗначений.ВозвратЛимита"));
		ДанныеЗаполнения.Вставить("МассивСтрокПревышения", ПараметрыВыполнения.КонтрольныеЗначения);
		
		ПараметрыФормы = Новый Структура; 
		ПараметрыФормы.Вставить("Основание", ДанныеЗаполнения);
		
		ОткрытьФорму("Документ.бит_КорректировкаКонтрольныхЗначений.ФормаОбъекта", ПараметрыФормы);
	Иначе
		ВызватьИсключение ПараметрыВыполнения.ТекстСообщения;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПараметрыВыполнения(ДокументСсылка)

	СтатусОбъекта  		= бит_Визирование.ПолучитьСтатусОбъекта(ДокументСсылка);
	Поддерживается 		= Истина;
	ТекстСообщения 		= "";
	КонтрольныеЗначения = Новый Массив(); 
	
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "Проведен") Тогда
		ТекстСообщения = НСтр("ru = 'Вводится на основании проведенного документа.'");
		Поддерживается = Ложь;
	КонецЕсли; 
	
	Если НЕ СтатусОбъекта.Статус = ПредопределенноеЗначение("Справочник.бит_СтатусыОбъектов.Заявка_Утверждена") 
		И НЕ СтатусОбъекта.Статус = ПредопределенноеЗначение("Справочник.бит_СтатусыОбъектов.Заявка_Оплачена") Тогда
		ТекстСообщения = НСтр("ru = 'Вводится на основании утвержденного или оплаченного документа.'");
		Поддерживается = Ложь;
	КонецЕсли; 
	
	Если Поддерживается Тогда
		КонтрольныеЗначения = Документы.бит_ЗаявкаНаРасходованиеСредств.КонтрольныеЗначенияВозвратаЛимита(ДокументСсылка);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Поддерживается", Поддерживается); 
	Результат.Вставить("ТекстСообщения", ТекстСообщения); 
	Результат.Вставить("КонтрольныеЗначения", КонтрольныеЗначения);

	Возврат Результат;

КонецФункции
 
#КонецОбласти