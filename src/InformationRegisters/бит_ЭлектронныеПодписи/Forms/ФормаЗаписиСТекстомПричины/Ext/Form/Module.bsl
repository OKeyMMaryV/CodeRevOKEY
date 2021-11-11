﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерЗаписи = Неопределено;
	
	Если Не Параметры.Ключ.Пустой()Тогда
		
		МенеджерЗаписи = бит_ЭлектронныеПодписи.ПолучитьЭлектроннуюПодпись(Запись.Объект, Запись.УстановившийПодпись,
			Запись.ДатаПодписи, Запись.ИД);
		
	ИначеЕсли Параметры.Свойство("Объект") И Параметры.Свойство("ИД") Тогда
		                 
		МенеджерЗаписи = бит_ЭлектронныеПодписи.ПолучитьЭлектроннуюПодпись(Параметры.Объект, , , Параметры.ИД);
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Не хватает параметров для открытия формы просмотра ЭП.'");
		
	КонецЕсли;
	
	Если МенеджерЗаписи = Неопределено Тогда
		ВызватьИсключение("Электронная подпись не найдена");
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(МенеджерЗаписи, "Запись");
	
	Если Не ЗначениеЗаполнено(Запись.Комментарий) Тогда
		Запись.Комментарий = НСтр("ru = 'Не указан'");
		Элементы.Комментарий.ЦветТекста = ЦветаСтиля.бит_ЦветНедоступногоПоля;
	КонецЕсли;
	
	Если ТипЗнч(Запись.Объект) = Тип("СправочникСсылка.ВерсииФайлов") Тогда
		ПодписанныйОбъект = Запись.Объект.ВладелецПредмета;
	Иначе
		ПодписанныйОбъект = Запись.Объект;
	КонецЕсли;
	
	ОбщийСтатусПроверки = бит_ЭлектронныеПодписи.ПолучитьОбщийСтатусПроверкиПодписи(Запись.ПодписьВерна,
		Запись.СертификатДействителен, Запись.ДатаПроверкиПодписи);
	
	СтатусПроверкиПодписи = бит_ЭлектронныеПодписи.ПолучитьСтатусПроверкиПодписи(Запись.ДатаПроверкиПодписи,
		Запись.ПодписьВерна, Запись.ТекстОшибкиПроверкиПодписи);
	СтатусПроверкиСертификата = бит_ЭлектронныеПодписи.ПолучитьСтатусПроверкиСертификата(Запись.ДатаПроверкиПодписи,
		Запись.СертификатДействителен, Запись.ТекстОшибкиПроверкиСертификата);
	
	Если ЗначениеЗаполнено(Запись.ТекстОшибкиПроверкиПодписи) Тогда
		ТекстПричины = Запись.ТекстОшибкиПроверкиПодписи;
		Элементы.ТекстПричины.Заголовок = НСтр("ru = 'Подпись не прошла проверку по причине'");
	ИначеЕсли ЗначениеЗаполнено(Запись.ТекстОшибкиПроверкиСертификата) Тогда
		Элементы.ТекстПричины.Заголовок = НСтр("ru = 'Сертификат не прошел проверку по причине'");
		ТекстПричины = Запись.ТекстОшибкиПроверкиСертификата;
	КонецЕсли;
	
	ОбщийСтатусПроверкиКартинка = 2;
	Если Не ЗначениеЗаполнено(Запись.ДатаПроверкиПодписи) Тогда
		ОбщийСтатусПроверкиКартинка = 1;
	ИначеЕсли Не Запись.ПодписьВерна Тогда
		ОбщийСтатусПроверкиКартинка = 3;
	КонецЕсли;
	
	Если ОбщийСтатусПроверкиКартинка = 2 Тогда
		Элементы.ГруппаОсновная.ЦветФона = ЦветаСтиля.бит_ФонПодписьВерна;
	ИначеЕсли ОбщийСтатусПроверкиКартинка = 3 Тогда
		Элементы.ГруппаОсновная.ЦветФона = ЦветаСтиля.бит_ФонПодписьНеверна;
	КонецЕсли;
	
	Если Параметры.Свойство("АдресПодписи") Тогда
		АдресПодписи = Параметры.АдресПодписи;
	Иначе
		ДвоичныеДанные = МенеджерЗаписи.Подпись.Получить();
		Если ДвоичныеДанные <> Неопределено Тогда 
			АдресПодписи = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("АдресСертификата") Тогда
		АдресСертификата = Параметры.АдресСертификата;
	Иначе
		ДвоичныеДанные = МенеджерЗаписи.Сертификат.Получить();
		Если ДвоичныеДанные <> Неопределено Тогда 
			АдресСертификата = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		Возврат;
	КонецЕсли;
	
	МодульЭлектроннаяПодписьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьКлиент");
	
	Если Не ЗначениеЗаполнено(АдресСертификата) Тогда
		МодульЭлектроннаяПодписьКлиент.ОткрытьСертификат(Запись.Отпечаток, Истина);
	Иначе
		МодульЭлектроннаяПодписьКлиент.ОткрытьСертификат(АдресСертификата, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выгрузить(Команда)
	
	ЭлектроннаяПодписьКлиент.СохранитьПодпись(АдресПодписи);
	
КонецПроцедуры

#КонецОбласти

