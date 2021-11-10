﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(КомпоновщикНастроек);
	Если КлючВарианта = "Т13" Тогда
		
		СтандартнаяОбработка = Ложь;
		Данные = Новый ДеревоЗначений;
		
		Попытка
			
			НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
			
			ПараметрОтчета = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОбозначениеБольничный"));
			Если ПараметрОтчета <> Неопределено Тогда
				ПараметрОтчета.Значение = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.Болезнь");
			КонецЕсли;
			
			ПараметрОтчета = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОбозначениеВыходной"));
			Если ПараметрОтчета <> Неопределено Тогда
				ПараметрОтчета.Значение = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.ВыходныеДни");
			КонецЕсли;
			
			ПараметрОтчета = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОбозначениеОтпуск"));
			Если ПараметрОтчета <> Неопределено Тогда
				ПараметрОтчета.Значение = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.ОсновнойОтпуск");
			КонецЕсли;
			
			ПараметрОтчета = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОбозначениеОтпускПоБеременностиИРодам"));
			Если ПараметрОтчета <> Неопределено Тогда
				ПараметрОтчета.Значение = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.ОтпускПоБеременностиИРодам");
			КонецЕсли;
			
			ПараметрОтчета = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОбозначениеЯвка"));
			Если ПараметрОтчета <> Неопределено Тогда
				ПараметрОтчета.Значение = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.Явка");
			КонецЕсли;
			
			ПараметрОтчета = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОбозначениеОтпускБезОплаты"));
			Если ПараметрОтчета <> Неопределено Тогда
				ПараметрОтчета.Значение = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.НеоплачиваемыйОтпускПоЗаконодательству");
			КонецЕсли;
			
			ПараметрОтчета = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПроизводственныйКалендарьРФ"));
			Если ПараметрОтчета <> Неопределено Тогда
				ПараметрОтчета.Значение = КалендарныеГрафики.ОсновнойПроизводственныйКалендарь();
			КонецЕсли;
			
			МакетКомпоновки = ЗарплатаКадрыОтчеты.МакетКомпоновкиДанныхДляКоллекцииЗначений(СхемаКомпоновкиДанных, НастройкиОтчета);
			
			// Создадим и инициализируем процессор компоновки.
			ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
			
			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
			ПроцессорВывода.УстановитьОбъект(Данные);
			
			// Обозначим начало вывода
			ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
			
			ВывестиУнифицированнуюФормуТ13ПоОрганизациям(ДокументРезультат, Данные.Строки);
			
		Исключение
			ВызватьИсключение НСтр("ru = 'В настройку отчета Т-13 внесены критичные изменения. Отчет не будет сформирован'") + ". " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
		ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
		ДопСвойства.Вставить("ОтчетПустой", Данные.Строки.Количество() = 0);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.Печать.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючСхемы <> "СхемаИнициализирована" Тогда
		
		ИнициализироватьОтчет();
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
		
		КлючСхемы = "СхемаИнициализирована";
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиУнифицированнуюФормуТ13ПоОрганизациям(ДокументРезультат, СтрокиДанных)
	
	// Сбор сведений о подписантах
	Подписанты = Новый Структура("Ответственный,ДолжностьОтветственного,Руководитель,ДолжностьРуководителя,Кадровик,ДолжностьКадровика");
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	Параметр = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Ответственный"));
	Если ЗначениеЗаполнено(Параметр.Значение) Тогда
		Подписанты.Ответственный = Параметр.Значение;
	КонецЕсли;
	
	Параметр = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОтветственныйДолжность"));
	Если ЗначениеЗаполнено(Параметр.Значение) Тогда
		Подписанты.ДолжностьОтветственного = Параметр.Значение;
	КонецЕсли;
	
	Параметр = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Руководитель"));
	Если ЗначениеЗаполнено(Параметр.Значение) Тогда
		Подписанты.Руководитель = Параметр.Значение;
	КонецЕсли;
	
	Параметр = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("РуководительДолжность"));
	Если ЗначениеЗаполнено(Параметр.Значение) Тогда
		Подписанты.ДолжностьРуководителя = Параметр.Значение;
	КонецЕсли;
	
	Параметр = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Кадровик"));
	Если ЗначениеЗаполнено(Параметр.Значение) Тогда
		Подписанты.Кадровик = Параметр.Значение;
	КонецЕсли;
	
	Параметр = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КадровикДолжность"));
	Если ЗначениеЗаполнено(Параметр.Значение) Тогда
		Подписанты.ДолжностьКадровика = Параметр.Значение;
	КонецЕсли;
	
	Для каждого СтрокаОрганизации Из СтрокиДанных Цикл
		
		ДанныеОрганизации = УчетРабочегоВремени.ДанныеОбОрганизацииПодразделенииДляТ13();
		ЗаполнитьЗначенияСвойств(ДанныеОрганизации, СтрокаОрганизации);
		ЗаполнитьЗначенияСвойств(ДанныеОрганизации, Подписанты);
		
		Для каждого СтрокаСотрудника Из СтрокаОрганизации.Строки Цикл
			
			ДанныеСотрудника = УчетРабочегоВремени.ДанныеОВремениСотрудникаДляТ13();
			ЗаполнитьЗначенияСвойств(ДанныеСотрудника, СтрокаСотрудника);
			
			Для каждого СтрокаДня Из СтрокаСотрудника.Строки Цикл
				
				ДанныеДня = УчетРабочегоВремени.ДанныеОРабочемВремениКалендарныхДней();
				ЗаполнитьЗначенияСвойств(ДанныеДня, СтрокаДня);
				
				ДанныеСотрудника.ДанныеКалендарныхДней.Добавить(ДанныеДня);
				
			КонецЦикла;
			
			ДанныеОрганизации.ДанныеСотрудников.Добавить(ДанныеСотрудника);
			
		КонецЦикла;
		
		УчетРабочегоВремени.ВывестиУнифицированнуюФормуТ13(ДокументРезультат, ДанныеОрганизации);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли