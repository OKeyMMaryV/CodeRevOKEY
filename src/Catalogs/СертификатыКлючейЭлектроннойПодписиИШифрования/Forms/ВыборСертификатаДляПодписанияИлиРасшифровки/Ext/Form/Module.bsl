﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ВнутренниеДанные, СвойстваПароля;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебный.НастроитьПояснениеВводаПароля(ЭтотОбъект,
		Элементы.СертификатУсиленнаяЗащитаЗакрытогоКлюча.Имя,
		Элементы.ПояснениеУсиленногоПароля.Имя);
	
	СертификатПараметрыРеквизитов = Новый Структура;
	Если Параметры.Свойство("Организация") Тогда
		СертификатПараметрыРеквизитов.Вставить("Организация", Параметры.Организация);
	КонецЕсли;
	
	ОтборПоОрганизации = Параметры.ОтборПоОрганизации;
	
	Если Параметры.ДобавлениеВСписок Тогда
		ДобавлениеВСписок = Истина;
		Элементы.Выбрать.Заголовок = НСтр("ru = 'Добавить'");
		
		Элементы.ПояснениеУсиленногоПароля.Заголовок =
			НСтр("ru = 'Нажмите Добавить, чтобы перейти к вводу пароля.'");
		
		ЛичныйСписокПриДобавлении = Параметры.ЛичныйСписокПриДобавлении;
		Элементы.ПоказыватьВсе.Подсказка =
			НСтр("ru = 'Показать все сертификаты без отбора (например, включая добавленные и просроченные)'");
	КонецЕсли;
	
	ДляШифрованияИРасшифровки = Параметры.ДляШифрованияИРасшифровки;
	ВернутьПароль = Параметры.ВернутьПароль;
	
	Если ДляШифрованияИРасшифровки = Истина Тогда
		Если Параметры.ДобавлениеВСписок Тогда
			Заголовок = НСтр("ru = 'Добавление сертификата для шифрования и расшифровки данных'");
		Иначе
			Заголовок = НСтр("ru = 'Выбор сертификата для шифрования и расшифровки данных'");
		КонецЕсли;
	ИначеЕсли ДляШифрованияИРасшифровки = Ложь Тогда
		Если Параметры.ДобавлениеВСписок Тогда
			Заголовок = НСтр("ru = 'Добавление сертификата для подписания данных'");
		КонецЕсли;
	ИначеЕсли ЭлектроннаяПодпись.ИспользоватьШифрование() Тогда
		Заголовок = НСтр("ru = 'Добавление сертификата для подписания и шифрования данных'");
	Иначе
		Заголовок = НСтр("ru = 'Добавление сертификата для подписания данных'");
	КонецЕсли;
	
	Если ЭлектроннаяПодпись.СоздаватьЭлектронныеПодписиНаСервере() Тогда
		Элементы.ГруппаСертификаты.Заголовок =
			НСтр("ru = 'Личные сертификаты на компьютере и сервере'");
	КонецЕсли;
	
	ЕстьОрганизации = Не Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(Тип("Строка"));
	Элементы.СертификатОрганизация.Видимость = ЕстьОрганизации;
	
	Элементы.СертификатПользователь.Подсказка =
		Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.Реквизиты.Пользователь.Подсказка;
	
	Элементы.СертификатОрганизация.Подсказка =
		Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.Реквизиты.Организация.Подсказка;
	
	Если ЗначениеЗаполнено(Параметры.ОтпечатокВыбранногоСертификата) Тогда
		ОтпечатокВыбранногоСертификатаНеНайден = Ложь;
		ОтпечатокВыбранногоСертификата = Параметры.ОтпечатокВыбранногоСертификата;
	Иначе
		ОтпечатокВыбранногоСертификата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Параметры.ВыбранныйСертификат, "Отпечаток");
	КонецЕсли;
	
	ОшибкаПолученияСертификатовНаКлиенте = Параметры.ОшибкаПолученияСертификатовНаКлиенте;
	ОбновитьСписокСертификатовНаСервере(Параметры.СвойстваСертификатовНаКлиенте);
	
	Если ЗначениеЗаполнено(Параметры.ОтпечатокВыбранногоСертификата)
	   И Параметры.ОтпечатокВыбранногоСертификата <> ОтпечатокВыбранногоСертификата Тогда
		
		ОтпечатокВыбранногоСертификатаНеНайден = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВнутренниеДанные = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_ПрограммыЭлектроннойПодписиИШифрования")
	 Или ВРег(ИмяСобытия) = ВРег("Запись_ПутиКПрограммамЭлектроннойПодписиИШифрованияНаСерверахLinux") Тогда
		
		ОбновитьПовторноИспользуемыеЗначения();
		ОбновитьСписокСертификатов();
		Возврат;
	КонецЕсли;
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
		ОбновитьСписокСертификатов();
		Возврат;
	КонецЕсли;
	
	Если ВРег(ИмяСобытия) = ВРег("Установка_РасширениеРаботыСКриптографией") Тогда
		ОбновитьСписокСертификатов();
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка уникальности наименования.
	ЭлектроннаяПодписьСлужебный.ПроверитьУникальностьПредставления(
		СертификатНаименование, Сертификат, "СертификатНаименование", Отказ);
		
	// Проверка заполнения организации.
	Если Элементы.СертификатОрганизация.Видимость
	   И Не Элементы.СертификатОрганизация.ТолькоПросмотр
	   И Элементы.СертификатОрганизация.АвтоОтметкаНезаполненного = Истина
	   И Не ЗначениеЗаполнено(СертификатОрганизация) Тогда
		
		ТекстСообщения = НСтр("ru = 'Поле Организация не заполнено.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "СертификатОрганизация",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Ссылка", Сертификат);
	ВозвращаемоеЗначение.Вставить("Добавлен", ЗначениеЗаполнено(Сертификат));
	Закрыть(ВозвращаемоеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СертификатыНедоступныНаКлиентеНадписьНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
		НСтр("ru = 'Сертификаты на компьютере'"), "", ОшибкаПолученияСертификатовНаКлиенте, Новый Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыНедоступныНаСервереНадписьНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
		НСтр("ru = 'Сертификаты на сервере'"), "", ОшибкаПолученияСертификатовНаСервере, Новый Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьВсеПриИзменении(Элемент)
	
	ОбновитьСписокСертификатов();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОткрытьИнструкциюПоРаботеСПрограммами();
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатУсиленнаяЗащитаЗакрытогоКлючаПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриИзмененииСвойствСертификата", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриИзмененииРеквизитаПароль", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьПарольПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриИзмененииРеквизитаЗапомнитьПароль", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеУстановленногоПароляНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПояснениеУстановленногоПароляНажатие(ЭтотОбъект, Элемент, СвойстваПароля);
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеУстановленногоПароляРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПояснениеУстановленногоПароляОбработкаНавигационнойСсылки(
		ЭтотОбъект, Элемент, НавигационнаяСсылка, СтандартнаяОбработка, СвойстваПароля);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификаты

&НаКлиенте
Процедура СертификатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Далее(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Сертификаты.ТекущиеДанные = Неопределено Тогда
		ОтпечатокВыбранногоСертификата = "";
	Иначе
		ОтпечатокВыбранногоСертификата = Элементы.Сертификаты.ТекущиеДанные.Отпечаток;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокСертификатов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДанныеТекущегоСертификата(Команда)
	
	ТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлектроннаяПодписьКлиент.ОткрытьСертификат(ТекущиеДанные.Отпечаток, Не ТекущиеДанные.ЭтоЗаявление);
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Элементы.Далее.Доступность = Ложь;
	
	ПерейтиКВыборуТекущегоСертификата(Новый ОписаниеОповещения(
		"ДалееПослеПереходаКВыборуТекущегоСертификата", ЭтотОбъект));
	
КонецПроцедуры

// Продолжение процедуры Далее.
&НаКлиенте
Процедура ДалееПослеПереходаКВыборуТекущегоСертификата(Результат, Контекст) Экспорт
	
	Если Результат = Истина Тогда
		Элементы.Далее.Доступность = Истина;
		Возврат;
	КонецЕсли;
	
	Контекст = Результат;
	
	Если Контекст.ОбновитьСписокСертификатов Тогда
		ОбновитьСписокСертификатов(Новый ОписаниеОповещения(
			"ДалееПослеОбновленияСпискаСертификатов", ЭтотОбъект, Контекст));
	Иначе
		ДалееПослеОбновленияСпискаСертификатов(Неопределено, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры Далее.
&НаКлиенте
Процедура ДалееПослеОбновленияСпискаСертификатов(Результат, Контекст) Экспорт
	
	ПоказатьПредупреждение(, Контекст.ОписаниеОшибки);
	Элементы.Далее.Доступность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.ГлавныеСтраницы.ТекущаяСтраница = Элементы.СтраницаВыборСертификата;
	Элементы.Далее.КнопкаПоУмолчанию = Истина;
	
	ОбновитьСписокСертификатов();
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если СертификатВОблачномСервисе Тогда
		
		МодульСервисКриптографииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииКлиент");
		МодульСервисКриптографииКлиент.ПроверитьСертификат(
			Новый ОписаниеОповещения("ВыбратьПослеПроверкиСертификатаВМоделиСервиса", ЭтотОбъект, Неопределено),
			ПолучитьИзВременногоХранилища(СертификатАдрес));
		
	Иначе
		
		ПараметрыСертификата = ЭлектроннаяПодписьКлиент.ПараметрыЗаписиСертификата();
		ПараметрыСертификата.Наименование = СертификатНаименование;
		ПараметрыСертификата.Пользователь = СертификатПользователь;
		ПараметрыСертификата.Организация = СертификатОрганизация;
		ПараметрыСертификата.УсиленнаяЗащитаЗакрытогоКлюча = СертификатУсиленнаяЗащитаЗакрытогоКлюча;
		
		ЭлектроннаяПодписьКлиент.ЗаписатьСертификатВСправочник(
			Новый ОписаниеОповещения("ВыбратьПослеПроверкиСертификата", ЭтотОбъект, Неопределено),
			СертификатАдрес, СвойстваПароля.Значение, ДляШифрованияИРасшифровки, ПараметрыСертификата);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры Выбрать.
&НаКлиенте
Процедура ВыбратьПослеПроверкиСертификата(Результат, Контекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	Если Не ЗначениеЗаполнено(Сертификат) Тогда
		ДополнительныеПараметры.Вставить("ЭтоНовый");
	КонецЕсли;
	
	Сертификат = Результат;
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриУспешномВыполненииОперации", Истина));
	
	ОповеститьОбИзменении(Сертификат);
	Оповестить("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования",
		ДополнительныеПараметры, Сертификат);
		
	Если ВернутьПароль Тогда
		
		ВнутренниеДанные.Вставить("ВыбранныйСертификат", Сертификат);
		Если Не ЗапомнитьПароль Тогда
			ВнутренниеДанные.Вставить("ВыбранныйСертификатПароль", СвойстваПароля.Значение);
		КонецЕсли;
		
		ОповеститьОВыборе(Истина);
		
	Иначе
		ОповеститьОВыборе(Сертификат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПослеПроверкиСертификатаВМоделиСервиса(Результат, Контекст) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	Если Не Результат.Выполнено Тогда
		ОписаниеОшибки = КраткоеПредставлениеОшибки(Результат.ИнформацияОбОшибке);
	ИначеЕсли Не Результат.Действителен Тогда
		ОписаниеОшибки = ЭлектроннаяПодписьСлужебныйКлиентСервер.ТекстОшибкиСервисаСертификатНедействителен();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		Если ДляШифрованияИРасшифровки = Истина Тогда
			ЗаголовокФормы = НСтр("ru = 'Проверка шифрования и расшифровки'");
		Иначе
			ЗаголовокФормы = НСтр("ru = 'Проверка установки электронной подписи'");
		КонецЕсли;
		ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
			ЗаголовокФормы, "", Новый Структура("ОписаниеОшибки", ОписаниеОшибки), Новый Структура);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Сертификат) Тогда
		ДополнительныеПараметры.Вставить("ЭтоНовый");
	КонецЕсли;
	
	ЗаписатьСертификатВСправочникВМоделиСервиса();
	
	ОповеститьОбИзменении(Сертификат);
	Оповестить("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования",
		ДополнительныеПараметры, Сертификат);
		
	ОповеститьОВыборе(Сертификат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДанныеСертификата(Команда)
	
	Если ЗначениеЗаполнено(СертификатАдрес) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(СертификатАдрес, Истина);
	Иначе
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(СертификатОтпечаток, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// АПК:78-выкл: для безопасной передачи данных на клиенте между формами, не отправляя их на сервер.
&НаКлиенте
Процедура ПродолжитьОткрытие(Оповещение, ОбщиеВнутренниеДанные) Экспорт
// АПК:78-вкл: для безопасной передачи данных на клиенте между формами, не отправляя их на сервер.
	
	ВнутренниеДанные = ОбщиеВнутренниеДанные;
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект, ВнутренниеДанные, СвойстваПароля);
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	
	Если ОтпечатокВыбранногоСертификатаНеНайден = Неопределено
	 Или ОтпечатокВыбранногоСертификатаНеНайден = Истина Тогда
		
		ПродолжитьОткрытиеПослеПереходаКВыборуТекущегоСертификата(Неопределено, Контекст);
	Иначе
		ПерейтиКВыборуТекущегоСертификата(Новый ОписаниеОповещения(
			"ПродолжитьОткрытиеПослеПереходаКВыборуТекущегоСертификата", ЭтотОбъект, Контекст));
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПродолжитьОткрытие.
&НаКлиенте
Процедура ПродолжитьОткрытиеПослеПереходаКВыборуТекущегоСертификата(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ОповеститьОВыборе(Ложь);
	Иначе
		Открыть();
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСвойстваТекущегоСертификатаНаСервере(Знач Отпечаток, СохраненныеСвойства);
	
	СертификатКриптографии = ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку(Отпечаток, Ложь);
	Если СертификатКриптографии = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СертификатАдрес = ПоместитьВоВременноеХранилище(СертификатКриптографии.Выгрузить(),
		УникальныйИдентификатор);
	
	СертификатОтпечаток = Отпечаток;
	
	ЭлектроннаяПодписьСлужебныйКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(СертификатОписаниеДанных,
		ЭлектроннаяПодпись.СвойстваСертификата(СертификатКриптографии));
	
	СохраненныеСвойства = СохраненныеСвойстваСертификата(Отпечаток,
		СертификатАдрес, СертификатПараметрыРеквизитов);
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция СохраненныеСвойстваСертификата(Знач Отпечаток, Знач Адрес, ПараметрыРеквизитов)
	
	Возврат ЭлектроннаяПодписьСлужебный.СохраненныеСвойстваСертификата(Отпечаток, Адрес, ПараметрыРеквизитов);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСписокСертификатов(Оповещение = Неопределено)
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьСвойстваСертификатовНаКлиенте(Новый ОписаниеОповещения(
		"ОбновитьСписокСертификатовПродолжение", ЭтотОбъект, Контекст), Истина, ПоказыватьВсе);
	
КонецПроцедуры

// Продолжение процедуры ОбновитьСписокСертификатов.
&НаКлиенте
Процедура ОбновитьСписокСертификатовПродолжение(Результат, Контекст) Экспорт
	
	ОшибкаПолученияСертификатовНаКлиенте = Результат.ОшибкаПолученияСертификатовНаКлиенте;
	
	ОбновитьСписокСертификатовНаСервере(Результат.СвойстваСертификатовНаКлиенте);
	
	Если Контекст.Оповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокСертификатовНаСервере(Знач СвойстваСертификатовНаКлиенте)
	
	ОшибкаПолученияСертификатовНаСервере = Новый Структура;
	
	ЭлектроннаяПодписьСлужебный.ОбновитьСписокСертификатов(Сертификаты, СвойстваСертификатовНаКлиенте,
		ДобавлениеВСписок, Истина, ОшибкаПолученияСертификатовНаСервере, ПоказыватьВсе, ОтборПоОрганизации);
	
	Если ЗначениеЗаполнено(ОтпечатокВыбранногоСертификата)
	   И (    Элементы.Сертификаты.ТекущаяСтрока = Неопределено
	      Или Сертификаты.НайтиПоИдентификатору(Элементы.Сертификаты.ТекущаяСтрока) = Неопределено
	      Или Сертификаты.НайтиПоИдентификатору(Элементы.Сертификаты.ТекущаяСтрока).Отпечаток
	              <> ОтпечатокВыбранногоСертификата) Тогда
		
		Отбор = Новый Структура("Отпечаток", ОтпечатокВыбранногоСертификата);
		Строки = Сертификаты.НайтиСтроки(Отбор);
		Если Строки.Количество() > 0 Тогда
			Элементы.Сертификаты.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаСертификатыНедоступныНаКлиенте.Видимость =
		ЗначениеЗаполнено(ОшибкаПолученияСертификатовНаКлиенте);
	
	Элементы.ГруппаСертификатыНедоступныНаСервере.Видимость =
		ЗначениеЗаполнено(ОшибкаПолученияСертификатовНаСервере);
	
	Если Элементы.Сертификаты.ТекущаяСтрока = Неопределено Тогда
		ОтпечатокВыбранногоСертификата = "";
	Иначе
		Строка = Сертификаты.НайтиПоИдентификатору(Элементы.Сертификаты.ТекущаяСтрока);
		ОтпечатокВыбранногоСертификата = ?(Строка = Неопределено, "", Строка.Отпечаток);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификата(Оповещение)
	
	Результат = Новый Структура;
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("ОбновитьСписокСертификатов", Ложь);
	
	Если Элементы.Сертификаты.ТекущиеДанные = Неопределено Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Выделите сертификат, который будет использоваться.'");
		ВыполнитьОбработкуОповещения(Оповещение, Результат);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	
	Если ТекущиеДанные.ЭтоЗаявление Тогда
		Результат.ОбновитьСписокСертификатов = Истина;
		Результат.ОписаниеОшибки =
			НСтр("ru = 'Для этого сертификата заявление на выпуск еще не исполнено.
			           |Откройте заявление на выпуск сертификата и выполните требуемые шаги.'");
		ВыполнитьОбработкуОповещения(Оповещение, Результат);
		Возврат;
	КонецЕсли;
	
	СертификатНаКлиенте = ТекущиеДанные.НаКлиенте;
	СертификатНаСервере = ТекущиеДанные.НаСервере;
	СертификатВОблачномСервисе = ТекущиеДанные.ВОблачномСервисе;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение",          Оповещение);
	Контекст.Вставить("Результат",           Результат);
	Контекст.Вставить("ТекущиеДанные",       ТекущиеДанные);
	Контекст.Вставить("СохраненныеСвойства", Неопределено);
	
	Если СертификатНаСервере Тогда
		Если ЗаполнитьСвойстваТекущегоСертификатаНаСервере(ТекущиеДанные.Отпечаток, Контекст.СохраненныеСвойства) Тогда
			ПерейтиКВыборуТекущегоСертификатаПослеЗаполненияСвойствСертификата(Контекст);
		Иначе
			Результат.ОписаниеОшибки = НСтр("ru = 'Сертификат отсутствует на сервере (возможно удален).'");
			Результат.ОбновитьСписокСертификатов = Истина;
			ВыполнитьОбработкуОповещения(Оповещение, Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ВОблачномСервисе Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Отпечаток", Base64Значение(ТекущиеДанные.Отпечаток));
		МодульХранилищеСертификатовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ХранилищеСертификатовКлиент");
		МодульХранилищеСертификатовКлиент.НайтиСертификат(Новый ОписаниеОповещения(
			"ПерейтиКВыборуТекущегоСертификатаПослеПоискаСертификатаВОблачномСервисе", ЭтотОбъект, Контекст), СтруктураПоиска);
	Иначе
		// СертификатНаКлиенте.
		ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьСертификатПоОтпечатку(
			Новый ОписаниеОповещения("ПерейтиКВыборуТекущегоСертификатаПослеПоискаСертификата", ЭтотОбъект, Контекст),
			ТекущиеДанные.Отпечаток, Ложь, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПерейтиКВыборуТекущегоСертификата.
&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификатаПослеПоискаСертификата(РезультатПоиска, Контекст) Экспорт
	
	Если ТипЗнч(РезультатПоиска) <> Тип("СертификатКриптографии") Тогда
		Если РезультатПоиска.Свойство("СертификатНеНайден") Тогда
			Контекст.Результат.ОписаниеОшибки = НСтр("ru = 'Сертификат не найден на компьютере (возможно удален).'");
		Иначе
			Контекст.Результат.ОписаниеОшибки = РезультатПоиска.ОписаниеОшибки;
		КонецЕсли;
		Контекст.Результат.ОбновитьСписокСертификатов = Истина;
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Контекст.Результат);
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("СертификатКриптографии", РезультатПоиска);
	
	Контекст.СертификатКриптографии.НачатьВыгрузку(Новый ОписаниеОповещения(
		"ПерейтиКВыборуТекущегоСертификатаПослеВыгрузкиСертификата", ЭтотОбъект, Контекст));
	
КонецПроцедуры

// Продолжение процедуры ПерейтиКВыборуТекущегоСертификата.
&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификатаПослеПоискаСертификатаВОблачномСервисе(РезультатПоиска, Контекст) Экспорт
	
	Если Не РезультатПоиска.Выполнено Тогда
		Контекст.Результат.ОписаниеОшибки = РезультатПоиска.ОписаниеОшибки.Описание;
		Контекст.Результат.ОбновитьСписокСертификатов = Истина;
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Контекст.Результат);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РезультатПоиска.Сертификат) Тогда
		Контекст.Результат.ОписаниеОшибки = НСтр("ru = 'Сертификат отсутствует в облачном сервисе (возможно удален).'");
		Контекст.Результат.ОбновитьСписокСертификатов = Истина;
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Контекст.Результат);
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("СертификатКриптографии", РезультатПоиска.Сертификат);
	ПерейтиКВыборуТекущегоСертификатаПослеВыгрузкиСертификата(РезультатПоиска.Сертификат.Сертификат, Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПерейтиКВыборуТекущегоСертификата.
&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификатаПослеВыгрузкиСертификата(ВыгруженныеДанные, Контекст) Экспорт
	
	СертификатАдрес = ПоместитьВоВременноеХранилище(ВыгруженныеДанные, УникальныйИдентификатор);
	
	СертификатОтпечаток = Контекст.ТекущиеДанные.Отпечаток;
	
	ЭлектроннаяПодписьСлужебныйКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(СертификатОписаниеДанных,
		ЭлектроннаяПодписьКлиент.СвойстваСертификата(Контекст.СертификатКриптографии));
	
	Контекст.СохраненныеСвойства = СохраненныеСвойстваСертификата(Контекст.ТекущиеДанные.Отпечаток,
		СертификатАдрес, СертификатПараметрыРеквизитов);
		
	Если ЗначениеЗаполнено(ОтборПоОрганизации) Тогда
		Контекст.СохраненныеСвойства.Вставить("Организация", ОтборПоОрганизации);
	КонецЕсли;
	
	ПерейтиКВыборуТекущегоСертификатаПослеЗаполненияСвойствСертификата(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПерейтиКВыборуТекущегоСертификата.
&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификатаПослеЗаполненияСвойствСертификата(Контекст)
	
	Если СертификатПараметрыРеквизитов.Свойство("Наименование") Тогда
		Если СертификатПараметрыРеквизитов.Наименование.ТолькоПросмотр Тогда
			Элементы.СертификатНаименование.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ЕстьОрганизации Тогда
		Если СертификатПараметрыРеквизитов.Свойство("Организация") Тогда
			Если Не СертификатПараметрыРеквизитов.Организация.Видимость Тогда
				Элементы.СертификатОрганизация.Видимость = Ложь;
			ИначеЕсли СертификатПараметрыРеквизитов.Организация.ТолькоПросмотр Тогда
				Элементы.СертификатОрганизация.ТолькоПросмотр = Истина;
			ИначеЕсли СертификатПараметрыРеквизитов.Организация.ПроверкаЗаполнения Тогда
				Элементы.СертификатОрганизация.АвтоОтметкаНезаполненного = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если СертификатПараметрыРеквизитов.Свойство("УсиленнаяЗащитаЗакрытогоКлюча") Тогда
		Если Не СертификатПараметрыРеквизитов.УсиленнаяЗащитаЗакрытогоКлюча.Видимость Тогда
			Элементы.СертификатУсиленнаяЗащитаЗакрытогоКлюча.Видимость = Ложь;
		ИначеЕсли СертификатПараметрыРеквизитов.УсиленнаяЗащитаЗакрытогоКлюча.ТолькоПросмотр Тогда
			Элементы.СертификатУсиленнаяЗащитаЗакрытогоКлюча.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Сертификат             = Контекст.СохраненныеСвойства.Ссылка;
	СертификатПользователь = Контекст.СохраненныеСвойства.Пользователь;
	СертификатОрганизация  = Контекст.СохраненныеСвойства.Организация;
	СертификатНаименование = Контекст.СохраненныеСвойства.Наименование;
	СертификатУсиленнаяЗащитаЗакрытогоКлюча = Контекст.СохраненныеСвойства.УсиленнаяЗащитаЗакрытогоКлюча;
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект, ВнутренниеДанные, СвойстваПароля);
	
	Элементы.ГлавныеСтраницы.ТекущаяСтраница = Элементы.СтраницаУточнениеСвойствСертификата;
	Элементы.Выбрать.КнопкаПоУмолчанию = Истина;
	
	Если ДобавлениеВСписок Тогда
		Строка = ?(ЗначениеЗаполнено(Сертификат), НСтр("ru = 'Обновить'"), НСтр("ru = 'Добавить'"));
		Если Элементы.Выбрать.Заголовок <> Строка Тогда
			Элементы.Выбрать.Заголовок = Строка;
		КонецЕсли;
	КонецЕсли;
	
	Если СертификатВОблачномСервисе Тогда
		Элементы.ГруппаУсиленнаяЗащитаЗакрытогоКлюча.Видимость = Ложь;
	Иначе
		Элементы.ГруппаУсиленнаяЗащитаЗакрытогоКлюча.Видимость = Истина;
		ПодключитьОбработчикОжидания("ОбработчикОжиданияАктивизироватьЭлементПароль", 0.1, Истина);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияАктивизироватьЭлементПароль()
	
	ТекущийЭлемент = Элементы.Пароль;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСертификатВСправочникВМоделиСервиса()
	
	ПрограммаОблачногоСервиса = ЭлектроннаяПодписьСлужебный.ПрограммаОблачногоСервиса();
	СертификатУсиленнаяЗащитаЗакрытогоКлюча = Ложь;
	
	ЭлектроннаяПодписьСлужебный.ЗаписатьСертификатВСправочник(ЭтотОбъект, ПрограммаОблачногоСервиса, Ложь);
	
КонецПроцедуры

#КонецОбласти
