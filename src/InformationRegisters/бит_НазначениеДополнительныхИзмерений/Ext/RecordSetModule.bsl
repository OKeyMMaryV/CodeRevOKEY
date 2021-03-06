#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Использованные.ИмяИзмерения КАК ИмяИзмерения,
	|	Использованные.Аналитика КАК Аналитика
	|ИЗ
	|	РегистрСведений.бит_НазначениеДополнительныхИзмерений КАК Использованные";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();

	Для каждого Запись Из ЭтотОбъект Цикл
		
		ЗначениеКлюча  = Новый Структура("ИмяИзмерения", Запись.ИмяИзмерения); 
		КлючЗаписи 	   = РегистрыСведений.бит_НазначениеДополнительныхИзмерений.СоздатьКлючЗаписи(ЗначениеКлюча);
				
		// Проверка на примитивные типы
		МассивТипов = Запись.Аналитика.ТипЗначения.Типы();		
		СтрТипы        = "";
		Для каждого ТекущийТип Из МассивТипов Цикл
			Если НЕ ОбщегоНазначения.ЭтоСсылка(ТекущийТип) Тогда
				СтрТипы = бит_СтрокиКлиентСервер.ДобавитьСтрокуСРазделителем(СтрТипы,Строка(ТекущийТип),", ");
			КонецЕсли; 
		КонецЦикла; // По типам
		
		Если НЕ ПустаяСтрока(СтрТипы) Тогда
			
			Пояснение = Нстр("ru = 'В составе типов обнаружены примитивные типы: %2. Допускаются только ссылочные типы.'");
			Пояснение = СтрШаблон(Пояснение, Запись.ИмяИзмерения, СтрТипы); 
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,"КОРРЕКТНОСТЬ",Нстр("ru = 'Аналитика'"),,,Пояснение);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, КлючЗаписи, "Запись.Аналитика", ,Отказ);
		КонецЕсли; 	
		
		Если НЕ Метаданные.ПланыСчетов.Найти("Хозрасчетный") = Неопределено Тогда
			// Проверка на использование счета в качестве измерения.
			Если Запись.Аналитика.ТипЗначения.СодержитТип(Тип("ПланСчетовСсылка.Хозрасчетный")) Тогда
				
				Пояснение 	   = НСтр("ru = 'Использование счетов в качестве дополнительных измерений запрещено.'");
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,"КОРРЕКТНОСТЬ",Нстр("ru = 'Аналитика'"),,,Пояснение);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, КлючЗаписи, "Запись.Аналитика", ,Отказ);
			КонецЕсли;	
		КонецЕсли;
		
		// На повторяемость.
		Выборка.Сбросить();
		Пока Выборка.НайтиСледующий(Новый Структура("Аналитика", Запись.Аналитика)) Цикл
			Если Выборка.ИмяИзмерения <> Запись.ИмяИзмерения Тогда
				Пояснение 	   = СтрШаблон(НСтр("ru = 'Аналитика ""%1"" уже используется в измерении ""%2"".'"),Запись.Аналитика, Выборка.ИмяИзмерения);
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,"КОРРЕКТНОСТЬ",Нстр("ru = 'Аналитика'"),,,Пояснение);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, КлючЗаписи, "Запись.Аналитика", ,Отказ);
			КонецЕсли; 
		КонецЦикла; 
	КонецЦикла; 	
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если Не Отказ Тогда	
		бит_ОбщиеПеременныеСервер.ЗначениеПеременнойУстановить("бит_НастройкиДополнительныхИзмерений"
		                               , бит_МеханизмДопИзмерений.ПолучитьНастройкиДополнительныхИзмерений()
									   , ИСТИНА);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
