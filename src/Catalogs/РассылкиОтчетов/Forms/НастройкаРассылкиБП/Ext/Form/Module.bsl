﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = Объект.Ссылка.Пустая();
	
	ИдентификаторТекущейСтрокиТаблицыОтчетов = -1;
	
	// Добавление отчетов в табличную часть.
	Если Параметры.Свойство("ПрисоединяемыеОтчеты") И ТипЗнч(Параметры.ПрисоединяемыеОтчеты) = Тип("Массив") Тогда
		ДобавитьНастройкиОтчетов(Параметры.ПрисоединяемыеОтчеты);
	КонецЕсли;
	
	Если ЭтоНовый Тогда
		
		// Архивацию отключаем, чтобы для просмотра отчетов в почтовом клиенте не требовалось выполнять лишних действий.
		Объект.Архивировать = Ложь;
		
		// Автор рассылки.
		Объект.Автор = ПользователиКлиентСервер.ТекущийПользователь();
		
		ВариантРасписания = Неопределено;
		Параметры.Свойство("ВариантРасписания", ВариантРасписания);
		ЗаполнитьРасписаниеПоУмолчанию(ВариантРасписания, ОбщегоНазначения.ТекущаяДатаПользователя());
		
		// Получатели рассылки хранятся в справочнике "КонтактныеЛица".
		Объект.ТипПолучателейРассылки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Справочник.КонтактныеЛица");
		
		// Заполним вид почтового адреса получателей значением по умолчанию.
		ТаблицаТиповПолучателей = РассылкаОтчетовПовтИсп.ТаблицаТиповПолучателей();
		СтрокаТипПолучателей    = ТаблицаТиповПолучателей.Найти(Объект.ТипПолучателейРассылки);
		Если СтрокаТипПолучателей <> Неопределено Тогда
			Объект.ВидПочтовогоАдресаПолучателей = СтрокаТипПолучателей.ОсновнойВидКИ;
		КонецЕсли;
		
		// Добавим формат по умолчанию (всегда xls).
		СтрокаФорматПоУмолчанию = Объект.ФорматыОтчетов.Добавить();
		СтрокаФорматПоУмолчанию.Отчет  = РассылкаОтчетов.ПустоеЗначениеОтчета();
		СтрокаФорматПоУмолчанию.Формат = Перечисления.ФорматыСохраненияОтчетов.XLS;
		
		Если НЕ ЗначениеЗаполнено(Объект.УчетнаяЗапись) Тогда
			Объект.УчетнаяЗапись = УчетнаяЗаписьДляОтправки();
		КонецЕсли;
		
		ПолучателиРассылки = ПолучателиРассылкиПоУмолчанию(Объект.УчетнаяЗапись);
		
	Иначе
		
		Расписание = РасписаниеРегламентногоЗадания(Объект.РегламентноеЗадание, Объект.ПериодичностьРасписания);
		ПолучателиРассылки = ПредставлениеПолучателей(Объект.Получатели, Объект.ВидПочтовогоАдресаПолучателей);
		
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Чтение шаблона письма.
	Если ТекущийОбъект.ПисьмоВФорматеHTML Тогда
		СтруктураВложенийПисьмаВФорматеHTML = ТекущийОбъект.КартинкиПисьмаВФорматеHTML.Получить();
		Если СтруктураВложенийПисьмаВФорматеHTML = Неопределено Тогда
			СтруктураВложенийПисьмаВФорматеHTML = Новый Структура;
		КонецЕсли;
		ТекстПисьмаФорматированныйДокумент.УстановитьHTML(ТекущийОбъект.ТекстПисьмаВФорматеHTML, СтруктураВложенийПисьмаВФорматеHTML);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ВыполнятьРассылку Тогда
		ПроверяемыеРеквизиты.Очистить();
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ПериодичностьРасписания) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , Нстр("ru = 'Когда'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, , "Объект.ПериодичностьРасписания", , Отказ);
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Объект удаляем из числа проверяемых реквизитов, поскольку все реквизиты объекта заполняются программно.
	МассивНепроверяемыхРеквизитов.Добавить("Объект");
	
	Если НЕ ДоступнаНастройкаПериодаОтчета Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВариантПериодаОтчета");
		МассивНепроверяемыхРеквизитов.Добавить("ВидПериодаОтчета");
	КонецЕсли;
	
	Если Объект.ПериодичностьРасписания = Перечисления.ПериодичностиРасписанийРассылокОтчетов.Ежедневно Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДеньНедели");
		МассивНепроверяемыхРеквизитов.Добавить("ДеньМесяца");
	ИначеЕсли Объект.ПериодичностьРасписания = Перечисления.ПериодичностиРасписанийРассылокОтчетов.Еженедельно Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДеньМесяца");
	ИначеЕсли Объект.ПериодичностьРасписания = Перечисления.ПериодичностиРасписанийРассылокОтчетов.Ежемесячно Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДеньНедели");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.Ссылка.Пустая()
		И НЕ ВыполнятьРассылку Тогда // Рассылку, которая не выполняется, создавать не нужно.
		Отказ = Истина;
		Модифицированность = Ложь;
		Закрыть();
		Возврат;
	КонецЕсли;
	
	Если ВыполнятьРассылку И НЕ ЗначениеЗаполнено(Объект.УчетнаяЗапись) Тогда
		ПоказатьПредупреждение(, Строка(ТекстПредупрежденияНеобходимоНастроитьУчетнуюЗапись()));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Разбираем строку с адресами электронной почты и проверяем адреса на корректность.
	СписокПолучателей = Новый ФиксированныйМассив(ОбщегоНазначенияКлиентСервер.АдресаЭлектроннойПочтыИзСтроки(ПолучателиРассылки));
	Для Каждого Получатель Из СписокПолучателей Цикл
		Если Не ПустаяСтрока(Получатель.ОписаниеОшибки) Тогда
			ПоказатьПредупреждение(, Получатель.ОписаниеОшибки, , Нстр("ru = 'Рассылка отчета'"));
			Отказ = Истина;
			
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.СозданаИзФормыОтчета = Истина;
	
	// Сохранение настроек отчета.
	Если ЭтоНовый Или ИзмененПериод Или ОбновитьНастройкиОтчетаВРассылке Тогда
		ПериодОтчета = СтандартныйПериодПоВидуПериода(ВариантПериодаОтчета, ВидПериодаОтчета);
		Для Каждого СтрокаОтчеты Из Объект.Отчеты Цикл
			
			Если НЕ СтрокаОтчеты.ДоступноИзменениеНастроек Тогда
				Продолжить;
			КонецЕсли;
			
			ОбъектСтрокаОтчеты = ТекущийОбъект.Отчеты.Получить(СтрокаОтчеты.НомерСтроки-1);
			
			Если ОбновитьНастройкиОтчетаВРассылке Тогда
				СтрокаОтчеты.АдресНастроек = СтрокаОтчеты.АдресНовыхНастроек;
			КонецЕсли;
			
			ПользовательскиеНастройки = ПолучитьИзВременногоХранилища(СтрокаОтчеты.АдресПользовательскихНастроек);
			НастройкиОтчета           = ПолучитьИзВременногоХранилища(СтрокаОтчеты.АдресНастроек);
			
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ПользовательскиеНастройки, "ПериодОтчета", ПериодОтчета, Истина);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ПользовательскиеНастройки, "НастройкиОтчета", НастройкиОтчета, Истина);
			
			ОбъектСтрокаОтчеты.Настройки = Новый ХранилищеЗначения(ПользовательскиеНастройки, Новый СжатиеДанных(9));
			
		КонецЦикла;
	КонецЕсли;
	
	// Сохранение получателей рассылки.
	СохранитьПолучателейРассылки(ТекущийОбъект, СписокПолучателей, Отказ);
	
	// Сохранение шаблона письма.
	ТекущийОбъект.КартинкиПисьмаВФорматеHTML = Неопределено;
	Если ТекущийОбъект.ПисьмоВФорматеHTML Тогда
		ТекущийОбъект.ТекстПисьма = СокрЛП(ТекстПисьмаФорматированныйДокумент.ПолучитьТекст());
		Если ТекущийОбъект.ТекстПисьма = "" Тогда
			ТекущийОбъект.ТекстПисьмаВФорматеHTML = "";
		Иначе
			ТекстПисьмаФорматированныйДокумент.ПолучитьHTML(ТекущийОбъект.ТекстПисьмаВФорматеHTML, СтруктураВложенийПисьмаВФорматеHTML);
			Если ТипЗнч(СтруктураВложенийПисьмаВФорматеHTML) = Тип("Структура")
				И СтруктураВложенийПисьмаВФорматеHTML.Количество() > 0 Тогда
				ТекущийОбъект.КартинкиПисьмаВФорматеHTML = Новый ХранилищеЗначения(СтруктураВложенийПисьмаВФорматеHTML, Новый СжатиеДанных(9));
			КонецЕсли;
			ТекущийОбъект.ТекстПисьма = ТекстПисьмаФорматированныйДокумент.ПолучитьТекст();
		КонецЕсли;
	КонецЕсли;
	
	// Заполнение расписания регламентного задания.
	Расписание = РасписаниеРегламентногоЗаданияПоДаннымФормы(Объект.ПериодичностьРасписания, ВремяНачала, ДеньНедели, ДеньМесяца);
	
	// Все операции с регламентными заданиями размещены в модуле объекта.
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Расписание", Расписание);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОВыборе(Новый Структура("РассылкаОтчетаСсылка, РассылкаОтчетаАктивна", Объект.Ссылка, ВыполнятьРассылку));
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыполнятьРассылкуПриИзменении(Элемент)
	
	Объект.Подготовлена = ВыполнятьРассылку;
	Объект.ВыполнятьПоРасписанию = ВыполнятьРассылку;
	
	УстановитьДоступность(ЭтотОбъект);
	УстановитьВидимостьПредупреждения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьРасписанияПриИзменении(Элемент)
	
	УстановитьВидимостьДополнительныхПолейРасписания(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьРасписанияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ДеньМесяцаПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ДеньМесяца) Тогда
		ДеньМесяца = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПериодаОтчетаПриИзменении(Элемент)
	
	ИзмененПериод = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПериодаОтчетаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВидПериодаОтчетаПриИзменении(Элемент)
	
	ИзмененПериод = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПериодаОтчетаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПредупреждениеУчетнаяЗаписьОтправителяОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "НастроитьУчетнуюЗапись" Тогда
		СтандартнаяОбработка = Ложь;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеНастройкиУчетнойЗаписиЭлектроннойПочты", ЭтотОбъект);
		РаботаСПочтовымиСообщениямиКлиент.ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьКлючСохраненияПоложенияОкнаФормы(Форма)
	
	СуффиксНетУчетнойЗаписи    = ?(ЗначениеЗаполнено(Форма.Объект.УчетнаяЗапись), "", "НетУчетнойЗаписи");
	СуффиксОтличаютсяНастройки = ?(НЕ Форма.ОтличаютсяНастройкиОтчета, "", "ОтличаютсяНастройкиОтчета");
	СуффиксПериодНеТребуется   = ?(Форма.ДоступнаНастройкаПериодаОтчета, "", "ПериодНеТребуется");
	
	Форма.КлючСохраненияПоложенияОкна = "РассылкаОтчетов" + СуффиксПериодНеТребуется + СуффиксНетУчетнойЗаписи + СуффиксОтличаютсяНастройки;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ВыполнятьРассылку = Объект.Подготовлена И Объект.ВыполнятьПоРасписанию;
	
	Если Расписание <> Неопределено Тогда
		ВремяНачала = Расписание.ВремяНачала;
		
		Если Расписание.ДниНедели.Количество() > 0 Тогда
			ДеньНедели = Расписание.ДниНедели[0];
		КонецЕсли;
		
		ДеньМесяца = Расписание.ДеньВМесяце;
	Иначе
		ВремяНачала = '00010101080000';// в 8:00 утра.
	КонецЕсли;
	
	Если ДеньНедели = 0 Тогда
		ДеньНедели = ДеньНедели(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;
	
	Если ДеньМесяца = 0 Тогда
		ДеньМесяца = День(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;
	
	ЗаполнитьСписокДнейМесяца(Элементы.ДеньМесяца);
	
	ЗаполнитьСписокВыбораВремени(Элементы.ВремяНачала);
	
	СтрокаОтчеты = Объект.Отчеты.НайтиПоИдентификатору(ИдентификаторТекущейСтрокиТаблицыОтчетов);
	Если СтрокаОтчеты <> Неопределено Тогда
		ПериодОтчетаИзНастроек = ПериодОтчетаИзПользовательскихНастроек(СтрокаОтчеты);
		
		ВариантПериодаОтчета = ПериодОтчетаИзНастроек.ВариантПериодаОтчета;
		ВидПериодаОтчета     = ПериодОтчетаИзНастроек.ВидПериодаОтчета;
		ДоступнаНастройкаПериодаОтчета = ПериодОтчетаИзНастроек.ДоступнаНастройкаПериодаОтчета;
	КонецЕсли;
	
	ПредупреждениеНетУчетнойЗаписиОтправителя = ТекстПредупрежденияНеобходимоНастроитьУчетнуюЗапись();
	
	Для Каждого СтрокаОтчеты Из Объект.Отчеты Цикл
		Если НЕ СтрокаОтчеты.ДоступноИзменениеНастроек Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаОтчеты.НастройкиОтличаются =
			НастройкиВРассылкеОтличаютсяОтНастроекОтчета(СтрокаОтчеты.АдресНастроек, СтрокаОтчеты.АдресНовыхНастроек);
		
		ОтличаютсяНастройкиОтчета = ОтличаютсяНастройкиОтчета ИЛИ СтрокаОтчеты.НастройкиОтличаются;
	КонецЦикла;
	
	ЗаполнитьПустыеШаблоныСтандартными(Объект, ТекстПисьмаФорматированныйДокумент);
	
	// Вложения.
	Если СтруктураВложенийПисьмаВФорматеHTML = Неопределено Тогда
		СтруктураВложенийПисьмаВФорматеHTML = Новый Структура;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	УстановитьДоступность(Форма);
	
	УстановитьВидимостьПредупреждения(Форма);
	
	УстановитьВидимостьДополнительныхПолейРасписания(Форма);
	
	Элементы.ГруппаНастройкиОтчета.Видимость = Форма.ОтличаютсяНастройкиОтчета;
	Элементы.ГруппаПериодОтчета.Видимость    = Форма.ДоступнаНастройкаПериодаОтчета;
	
	УстановитьКлючСохраненияПоложенияОкнаФормы(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступность(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаПараметрыРассылки.Доступность = Форма.ВыполнятьРассылку;
	Элементы.ГруппаНастройкиОтчета.Доступность   = Форма.ВыполнятьРассылку;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьПредупреждения(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаПредупреждение.Видимость = Форма.ВыполнятьРассылку И НЕ ЗначениеЗаполнено(Объект.УчетнаяЗапись);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДополнительныхПолейРасписания(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаПериодичностьЕженедельно.Видимость =
		Объект.ПериодичностьРасписания = ПредопределенноеЗначение("Перечисление.ПериодичностиРасписанийРассылокОтчетов.Еженедельно");
	
	Элементы.ГруппаПериодичностьЕжемесячно.Видимость =
		Объект.ПериодичностьРасписания = ПредопределенноеЗначение("Перечисление.ПериодичностиРасписанийРассылокОтчетов.Ежемесячно");
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьПустыеШаблоныСтандартными(ТекущийОбъект, ФорматированныйДокумент)
	// Данные объекта
	Если ПустаяСтрока(ТекущийОбъект.ТемаПисьма) Тогда
		ТекущийОбъект.ТемаПисьма = ШаблонТемы();
	КонецЕсли;
	Если ПустаяСтрока(ТекущийОбъект.ТекстПисьма) Тогда
		ТекущийОбъект.ТекстПисьма = ШаблонТекста();
	КонецЕсли;
	Если ПустаяСтрока(ТекущийОбъект.ИмяАрхива) Тогда
		ТекущийОбъект.ИмяАрхива = РассылкаОтчетов.ШаблонИмениАрхива();
	КонецЕсли;
	// Данные формы
	Если ПустаяСтрока(ФорматированныйДокумент.ПолучитьТекст()) Тогда
		ФорматированныйДокумент.Добавить(ШаблонТекста(), ТипЭлементаФорматированногоДокумента.Текст);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ШаблонТемы() Экспорт
	Возврат НСтр("ru = '[ПредставлениеОтчета]'");
КонецФункции

&НаСервереБезКонтекста
Функция ШаблонТекста() Экспорт
	Возврат НСтр(
		"ru = 'К письму приложены файлы:
		|[СформированныеОтчетыМаркированныйСписок]
		|
		|[ПодписьАвтора]'");
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстПредупрежденияНеобходимоНастроитьУчетнуюЗапись()
	
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(Нстр("ru = 'Для отправки отчета настройте '"));
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(Нстр("ru = 'учетную запись электронной почты'"), , , , "НастроитьУчетнуюЗапись"));
	
	Возврат Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецФункции

&НаСервере
Процедура ДобавитьНастройкиОтчетов(ПрисоединяемыеОтчеты)
	
	Для Каждого СтрокаОтчетыПараметры Из ПрисоединяемыеОтчеты Цикл
		Если СтрокаОтчетыПараметры.Свойство("ВариантСсылка")
			И ТипЗнч(СтрокаОтчетыПараметры.ВариантСсылка) = Тип("СправочникСсылка.ВариантыОтчетов")
			И СтрокаОтчетыПараметры.ВариантСсылка <> Справочники.ВариантыОтчетов.ПустаяСсылка() Тогда
			ВариантСсылка = СтрокаОтчетыПараметры.ВариантСсылка;
		Иначе
			ОтчетИнформация = ВариантыОтчетов.ИнформацияОбОтчете(СтрокаОтчетыПараметры.ОтчетПолноеИмя);
			ВариантСсылка = ВариантыОтчетов.ВариантОтчета(ОтчетИнформация.Отчет, СтрокаОтчетыПараметры.КлючВарианта);
		КонецЕсли;
		
		Если ВариантСсылка.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
			Объект.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВариантСсылка, "Наименование");
		КонецЕсли;
		
		Найденные = Объект.Отчеты.НайтиСтроки(Новый Структура("Отчет", ВариантСсылка));
		Если Найденные.Количество() > 0 Тогда
			СтрокаОтчеты = Найденные[0];
		Иначе
			СтрокаОтчеты = Объект.Отчеты.Добавить();
			СтрокаОтчеты.Отчет                = ВариантСсылка;
			СтрокаОтчеты.ОтправлятьЕслиПустой = Истина;
		КонецЕсли;
		
		СтрокаОтчеты.ДоступноИзменениеНастроек = Истина;
		
		ПользовательскиеНастройкиКД = СтрокаОтчетыПараметры.Настройки;
		
		Если ЭтоНовый Тогда
			Адрес = ?(ЭтоАдресВременногоХранилища(СтрокаОтчеты.АдресПользовательскихНастроек), СтрокаОтчеты.АдресПользовательскихНастроек, УникальныйИдентификатор);
			
			СтрокаОтчеты.АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(ПользовательскиеНастройкиКД, Адрес);
			
			Адрес = ?(ЭтоАдресВременногоХранилища(СтрокаОтчетыПараметры.АдресНастроекОтчета), СтрокаОтчетыПараметры.АдресНастроекОтчета, "");
			СтрокаОтчеты.АдресНастроек = Адрес;
		Иначе
			Адрес = ?(ЭтоАдресВременногоХранилища(СтрокаОтчеты.АдресПользовательскихНастроек), СтрокаОтчеты.АдресПользовательскихНастроек, УникальныйИдентификатор);
			СтрокаОтчеты.АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(ПользовательскиеНастройкиКД, Адрес);
			
			// Для сравнения настроек необходимо поместить во временное хранилище настройки отчета из рассылки,
			// поскольку они недоступны в данных формы.
			Индекс = Объект.Отчеты.Индекс(СтрокаОтчеты);
			ОбъектСтрокаОтчеты = РеквизитФормыВЗначение("Объект").Отчеты.Получить(Индекс);
			НастройкиОтчета    = ?(ОбъектСтрокаОтчеты = Неопределено, Неопределено, ОбъектСтрокаОтчеты.Настройки.Получить());
			
			ПараметрНастройкиОтчета = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "НастройкиОтчета");
			Если ПараметрНастройкиОтчета <> Неопределено Тогда
				СтрокаОтчеты.АдресНастроек = ПоместитьВоВременноеХранилище(ПараметрНастройкиОтчета.Значение, Адрес);
			КонецЕсли;
			
			АдресНовыхНастроек = ?(ЭтоАдресВременногоХранилища(СтрокаОтчетыПараметры.АдресНастроекОтчета), СтрокаОтчетыПараметры.АдресНастроекОтчета, УникальныйИдентификатор);
			СтрокаОтчеты.АдресНовыхНастроек = АдресНовыхНастроек;
		КонецЕсли;
		
		ИдентификаторТекущейСтрокиТаблицыОтчетов = СтрокаОтчеты.ПолучитьИдентификатор();
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УчетнаяЗаписьДляОтправки()
	
	УчетнаяЗапись = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("УчетнаяЗаписьЭлектроннойПочты");
	Если НЕ ЗначениеЗаполнено(УчетнаяЗапись) Или НЕ РаботаСПочтовымиСообщениями.УчетнаяЗаписьНастроена(УчетнаяЗапись, Истина) Тогда
		// Учетная запись в персональных настройках не указана, выбираем первую доступную.
		ДоступныеУчетныеЗаписи = РаботаСПочтовымиСообщениями.ДоступныеУчетныеЗаписи(Истина);
		Если ДоступныеУчетныеЗаписи.Количество() > 0 Тогда
			УчетнаяЗапись = ДоступныеУчетныеЗаписи[0].Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Возврат УчетнаяЗапись;
	
КонецФункции

#Область ОбработчикиРасписанияИПредставленияПериода

&НаСервере
Процедура ЗаполнитьРасписаниеПоУмолчанию(Вариант, ДатаСоздания)
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	
	// По умолчанию отчет отправится в ближайшие 30 минут.
	Расписание.ВремяНачала = БлижайшееВремя();
	
	// Каждый день.
	Расписание.ПериодПовтораДней = 1;
	
	// По дням недели.
	ДеньНеделиМин = 1;
	ДеньНеделиМакс = 7;
	
	Объект.ПериодичностьРасписания = Вариант;
	Если Объект.ПериодичностьРасписания = Перечисления.ПериодичностиРасписанийРассылокОтчетов.Еженедельно Тогда
		ДеньНедели = ДеньНедели(ДатаСоздания);
		ДеньНеделиМин = ДеньНедели;
		ДеньНеделиМакс = ДеньНедели;
		
	ИначеЕсли Объект.ПериодичностьРасписания = Перечисления.ПериодичностиРасписанийРассылокОтчетов.Ежемесячно Тогда
		Расписание.ДеньВМесяце = День(ДатаСоздания);
		
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.ПериодичностьРасписания) Тогда
		Объект.ПериодичностьРасписания = Перечисления.ПериодичностиРасписанийРассылокОтчетов.Ежедневно;
		
	КонецЕсли;
	
	// По дням недели.
	ВыбранныеДниНедели = Новый Массив;
	Для Индекс = ДеньНеделиМин По ДеньНеделиМакс Цикл
		ВыбранныеДниНедели.Добавить(Индекс);
	КонецЦикла;
	Расписание.ДниНедели = ВыбранныеДниНедели;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция БлижайшееВремя()
	
	ТекущееВремяПользователя = ТекущаяДатаСеанса();
	
	// Интервал - 30 минут.
	Часы = Час(ТекущееВремяПользователя);
	Минуты = Минута(ТекущееВремяПользователя);
	
	Если Минуты > 30 Тогда
		Часы = Часы + 1;
		Минуты = 0;
	ИначеЕсли Минуты < 30 И Минуты > 0 Тогда
		Минуты = 30;
	КонецЕсли;
	
	Возврат Дата(1, 1, 1, Часы, Минуты, 0);
	
КонецФункции

&НаСервереБезКонтекста
Функция РасписаниеРегламентногоЗадания(Знач ИдентификаторЗадания, ПериодичностьРасписания)
	УстановитьПривилегированныйРежим(Истина);
	Если ТипЗнч(ИдентификаторЗадания) = Тип("УникальныйИдентификатор") Тогда
		// Из-за того, что регламентное задание создается платформенным способом (см. ПередЗаписью объекта),
		// то и искать его нужно платформенным способом,
		// а не через программный интерфейс общего модуля РегламентныеЗаданияСервер
		Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
		Если Задание <> Неопределено Тогда
			Расписание = Задание.Расписание;
			Если ПериодичностьРасписания <> Перечисления.ПериодичностиРасписанийРассылокОтчетов.Произвольное Тогда
				Расписание.ВремяКонца = '00010101';
			КонецЕсли;
			
			Возврат Расписание;
		КонецЕсли;
	КонецЕсли;
КонецФункции

&НаСервереБезКонтекста
Функция РасписаниеРегламентногоЗаданияПоДаннымФормы(Периодичность, ВремяНачала, ДеньНедели, ДеньВМесяце)
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ВремяНачала = ВремяНачала;
	Расписание.ПериодПовтораДней = 1;
	
	Если Периодичность = Перечисления.ПериодичностиРасписанийРассылокОтчетов.Еженедельно Тогда
		Расписание.ДниНедели = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДеньНедели);
	КонецЕсли;
	
	Если Периодичность = Перечисления.ПериодичностиРасписанийРассылокОтчетов.Ежемесячно Тогда
		ВсеМесяцы = Новый Массив;
		Для Индекс = 1 По 12 Цикл
			ВсеМесяцы.Добавить(Индекс);
		КонецЦикла;
		Расписание.Месяцы = ВсеМесяцы;
		Расписание.ДеньВМесяце = ДеньВМесяце;
	КонецЕсли;
	
	// Все операции с регламентными заданиями размещены в модуле объекта.
	Если Периодичность <> Перечисления.ПериодичностиРасписанийРассылокОтчетов.Произвольное Тогда
		Расписание.ВремяКонца = Расписание.ВремяНачала + 600;
	КонецЕсли;
	
	Возврат Расписание;
	
КонецФункции

&НаСервере
Функция ПериодОтчетаИзПользовательскихНастроек(СтрокаОтчеты)
	
	Если ЭтоНовый Тогда
		ПользовательскиеНастройкиКД = ПолучитьИзВременногоХранилища(СтрокаОтчеты.АдресПользовательскихНастроек);
	Иначе
		Индекс = Объект.Отчеты.Индекс(СтрокаОтчеты);
		ОбъектСтрокаОтчеты = РеквизитФормыВЗначение("Объект").Отчеты.Получить(Индекс);
		ПользовательскиеНастройкиКД = ?(ОбъектСтрокаОтчеты = Неопределено, Неопределено, ОбъектСтрокаОтчеты.Настройки.Получить());
	КонецЕсли;
	
	Результат = Новый Структура("ВариантПериодаОтчета, ВидПериодаОтчета, ДоступнаНастройкаПериодаОтчета",
		"Текущий", Перечисления.ДоступныеПериодыОтчета.Месяц, Истина);
	
	ЗначениеПараметра = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(ПользовательскиеНастройкиКД, "ПериодОтчета");
	
	Если ЗначениеПараметра = Неопределено Тогда
		Результат.ДоступнаНастройкаПериодаОтчета = Ложь;
		Возврат Результат;
	КонецЕсли;
	
	Период = ЗначениеПараметра.Значение;
	ВидПериода = ПолучитьВидСтандартногоПериода(Период);
	Если ВидПериода = Перечисления.ДоступныеПериодыОтчета.ПроизвольныйПериод Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат.ВидПериодаОтчета = ВидПериода;
	
	Если ЭтоПредыдущийПериод(Период) Тогда
		Результат.ВариантПериодаОтчета = "Прошлый";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоПредыдущийПериод(СтандартныйПериод)
	
	Возврат ЗначениеЗаполнено(СтандартныйПериод.ДатаОкончания)
		И СтандартныйПериод.ДатаОкончания < ОбщегоНазначения.ТекущаяДатаПользователя();
	
КонецФункции

&НаСервереБезКонтекста
Функция СтандартныйПериодПоВидуПериода(ОтносительныйПериод, ВидПериода)
	
	ЭтоПрошлыйПериод = ВРег(ОтносительныйПериод) = ВРег("Прошлый");
	Если ВидПериода = Перечисления.ДоступныеПериодыОтчета.День Тогда
		
		Если ЭтоПрошлыйПериод Тогда
			Возврат Новый СтандартныйПериод(ВариантСтандартногоПериода.Вчера);
		Иначе
			Возврат Новый СтандартныйПериод(ВариантСтандартногоПериода.Сегодня);
		КонецЕсли;
		
	ИначеЕсли ВидПериода = Перечисления.ДоступныеПериодыОтчета.Неделя Тогда
		
		Если ЭтоПрошлыйПериод Тогда
			Возврат Новый СтандартныйПериод(ВариантСтандартногоПериода.ПрошлаяНеделя);
		Иначе
			Возврат Новый СтандартныйПериод(ВариантСтандартногоПериода.ЭтаНеделя);
		КонецЕсли;
		
	ИначеЕсли ВидПериода = Перечисления.ДоступныеПериодыОтчета.Месяц Тогда
		
		Если ЭтоПрошлыйПериод Тогда
			Возврат Новый СтандартныйПериод(ВариантСтандартногоПериода.ПрошлыйМесяц);
		Иначе
			Возврат Новый СтандартныйПериод(ВариантСтандартногоПериода.ЭтотМесяц);
		КонецЕсли;
		
	ИначеЕсли ВидПериода = Перечисления.ДоступныеПериодыОтчета.Квартал Тогда
		
		Если ЭтоПрошлыйПериод Тогда
			Возврат Новый СтандартныйПериод(ВариантСтандартногоПериода.ПрошлыйКвартал);
		Иначе
			Возврат Новый СтандартныйПериод(ВариантСтандартногоПериода.ЭтотКвартал);
		КонецЕсли;
		
	ИначеЕсли ВидПериода = Перечисления.ДоступныеПериодыОтчета.Год Тогда
		
		Если ЭтоПрошлыйПериод Тогда
			Возврат Новый СтандартныйПериод(ВариантСтандартногоПериода.ПрошлыйГод);
		Иначе
			Возврат Новый СтандартныйПериод(ВариантСтандартногоПериода.ЭтотГод);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Новый СтандартныйПериод(ВариантСтандартногоПериода.Сегодня);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВидСтандартногоПериода(СтандартныйПериод) Экспорт
	
	Если СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод Тогда
		
		Возврат ВыборПериодаКлиентСервер.ПолучитьВидПериода(СтандартныйПериод.ДатаНачала, СтандартныйПериод.ДатаОкончания);
		
	ИначеЕсли СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ЭтотГод
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлыйГод
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующийГод
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СНачалаЭтогоГода
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ДоКонцаЭтогоГода
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлыйГодДоТакойЖеДаты
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующийГодДоТакойЖеДаты Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Год");
		
	ИначеЕсли СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ЭтоПолугодие
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлоеПолугодие
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующееПолугодие
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СНачалаЭтогоПолугодия
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ДоКонцаЭтогоПолугодия
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлоеПолугодиеДоТакойЖеДаты
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующееПолугодиеДоТакойЖеДаты Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Полугодие");
		
	ИначеЕсли СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ЭтотКвартал
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлыйКвартал
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующийКвартал
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СНачалаЭтогоКвартала
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ДоКонцаЭтогоКвартала
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлыйКварталДоТакойЖеДаты
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующийКварталДоТакойЖеДаты Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Квартал");
		
	ИначеЕсли СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ЭтотМесяц
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяц
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующийМесяц
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.Месяц
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СНачалаЭтогоМесяца
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ДоКонцаЭтогоМесяца
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяцДоТакойЖеДаты
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующийМесяцДоТакойЖеДаты Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Месяц");
		
	ИначеЕсли СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ЭтаДекада
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлаяДекада
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующаяДекада
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СНачалаЭтойДекады
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ДоКонцаЭтойДекады
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлаяДекадаДоТакогоЖеНомераДня
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующаяДекадаДоТакогоЖеНомераДня Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Декада");
		
	ИначеЕсли СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ЭтаНеделя
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлаяНеделя
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующаяНеделя
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СНачалаЭтойНедели
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ДоКонцаЭтойНедели
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.Последние7Дней
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.Следующие7Дней
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлаяНеделяДоТакогоЖеДняНедели
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующаяНеделяДоТакогоЖеДняНедели Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Неделя");
		
	ИначеЕсли СтандартныйПериод.Вариант = ВариантСтандартногоПериода.Сегодня
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.Вчера
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.Завтра Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.День");
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СравнениеНастроекОтчета

&НаСервереБезКонтекста
Функция НастройкиВРассылкеОтличаютсяОтНастроекОтчета(АдресНастроекРассылки, АдресНастроекОтчета)
	
	Если НЕ ЭтоАдресВременногоХранилища(АдресНастроекОтчета) Тогда
		Возврат Ложь; // В новой рассылке АдресНастроекОтчета будет пустым, т.к. настройки в рассылку копируются всегда.
	КонецЕсли;
	
	ДанныеОтчетаВРассылке = ПолучитьДанныеОтчетаИзНастроек(АдресНастроекРассылки);
	ДанныеОтчетаВОтчете   = ПолучитьДанныеОтчетаИзНастроек(АдресНастроекОтчета);
	
	Возврат НЕ РассылкаОтчетовБП.КоллекцииНастроекОтчетаИдентичны(ДанныеОтчетаВРассылке, ДанныеОтчетаВОтчете);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеОтчетаИзНастроек(АдресНастроек)
	
	НастройкиОтчета = ПолучитьИзВременногоХранилища(АдресНастроек);
	Если НастройкиОтчета <> Неопределено Тогда
		Возврат НастройкиОтчета.Получить();
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ЧтениеСохранениеПолучателейРассылки

&НаСервереБезКонтекста
Функция ПолучателиРассылкиПоУмолчанию(УчетнаяЗаписьПоУмолчанию)
	
	Результат = "";
	
	// По умолчанию получателем отчета всегда является текущий пользователь.
	Если ЗначениеЗаполнено(УчетнаяЗаписьПоУмолчанию) Тогда
		Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗаписьПоУмолчанию, "АдресЭлектроннойПочты");
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Результат) Тогда
		Результат = Результат + ";";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПредставлениеПолучателей(ЗНАЧ Получатели, ЗНАЧ ВидПочтовогоАдресаПолучателей)
	
	Включенные = Получатели.Выгрузить(Новый Структура("Исключен", Ложь));
	
	Если Включенные.Количество() = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Представление КАК Представление,
	|	Таблица.АдресЭП КАК АдресЭП
	|ИЗ
	|	" + Включенные[0].Получатель.Метаданные().ПолноеИмя() + ".КонтактнаяИнформация КАК Таблица
	|ГДЕ
	|	Таблица.Вид = &ВидКИ
	|	И Таблица.Ссылка В(&Получатели)";
	
	Запрос.УстановитьПараметр("Получатели", Включенные.ВыгрузитьКолонку("Получатель"));
	Запрос.УстановитьПараметр("ВидКИ", ВидПочтовогоАдресаПолучателей);
	
	Выборка = Запрос.Выполнить().Выбрать();
	МассивПолучателей = Новый Массив;
	Пока Выборка.Следующий() Цикл
		МассивПолучателей.Добавить(Выборка.АдресЭП);
	КонецЦикла;
	
	Разделитель = "; ";
	Возврат СтрСоединить(МассивПолучателей, Разделитель) + Разделитель;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьПолучателейРассылки(ТекущийОбъект, СписокПолучателей, Отказ)
	
	ТаблицаПолучателей = НоваяТаблицаПолучателей();
	Для Каждого Получатель Из СписокПолучателей Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаПолучателей.Добавить(), Получатель);
	КонецЦикла;
	
	ТекущийОбъект.Получатели.Очистить();
	
	// Попробуем найти получателей среди личных контактов и прочих контактных лиц.
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПолучателиРассылки.Псевдоним КАК Псевдоним,
	|	ВЫРАЗИТЬ(ПолучателиРассылки.Адрес КАК СТРОКА(100)) КАК Адрес
	|ПОМЕСТИТЬ ВТ_ПолучателиРассылки
	|ИЗ
	|	&ПолучателиРассылки КАК ПолучателиРассылки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонтактныеЛицаКонтактнаяИнформация.Ссылка КАК Ссылка,
	|	КонтактныеЛицаКонтактнаяИнформация.АдресЭП КАК АдресЭП
	|ПОМЕСТИТЬ ВТ_КонтактныеЛица
	|ИЗ
	|	Справочник.КонтактныеЛица.КонтактнаяИнформация КАК КонтактныеЛицаКонтактнаяИнформация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛица КАК КонтактныеЛица
	|		ПО КонтактныеЛицаКонтактнаяИнформация.Ссылка = КонтактныеЛица.Ссылка
	|ГДЕ
	|	КонтактныеЛица.ВидКонтактногоЛица = ЗНАЧЕНИЕ(Перечисление.ВидыКонтактныхЛиц.ЛичныйКонтакт)
	|	И КонтактныеЛица.ПользовательЛичногоКонтакта = &ПользовательЛичногоКонтакта
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КонтактныеЛицаКонтактнаяИнформация.Ссылка,
	|	КонтактныеЛицаКонтактнаяИнформация.АдресЭП
	|ИЗ
	|	Справочник.КонтактныеЛица.КонтактнаяИнформация КАК КонтактныеЛицаКонтактнаяИнформация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛица КАК КонтактныеЛица
	|		ПО КонтактныеЛицаКонтактнаяИнформация.Ссылка = КонтактныеЛица.Ссылка
	|ГДЕ
	|	КонтактныеЛица.ВидКонтактногоЛица = ЗНАЧЕНИЕ(Перечисление.ВидыКонтактныхЛиц.ПрочееКонтактноеЛицо)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПолучателиРассылки.Псевдоним КАК Псевдоним,
	|	ПолучателиРассылки.Адрес КАК АдресЭП,
	|	КонтактныеЛица.Ссылка КАК Контакт,
	|	ВЫБОР
	|		КОГДА КонтактныеЛица.Ссылка ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК КонтактНайден
	|ИЗ
	|	ВТ_ПолучателиРассылки КАК ПолучателиРассылки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КонтактныеЛица КАК КонтактныеЛица
	|		ПО (КонтактныеЛица.АдресЭП = ПолучателиРассылки.Адрес)";
	
	Запрос.УстановитьПараметр("ПолучателиРассылки", ТаблицаПолучателей);
	Запрос.УстановитьПараметр("ПользовательЛичногоКонтакта", ТекущийОбъект.Автор);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.КонтактНайден Тогда
			Получатель = Выборка.Контакт;
		Иначе
			Получатель = СоздатьКонтактноеЛицо(ТекущийОбъект.Автор, СокрЛП(Выборка.Псевдоним), ТекущийОбъект.ВидПочтовогоАдресаПолучателей, СокрЛП(Выборка.АдресЭП));
		КонецЕсли;
		
		Если Получатель <> Неопределено Тогда
			СтрокаПолучатели = ТекущийОбъект.Получатели.Добавить();
			СтрокаПолучатели.Получатель = Получатель;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НоваяТаблицаПолучателей()
	
	ТипСтрока100 = ОбщегоНазначения.ОписаниеТипаСтрока(100);
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Псевдоним", ТипСтрока100);
	Результат.Колонки.Добавить("Адрес",     ТипСтрока100);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция СоздатьКонтактноеЛицо(Владелец, ЗНАЧ Наименование, ВидКонтактнойИнформации, ЗНАЧ АдресЭП)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ОбъектВладелец", Владелец);
	ЗначенияЗаполнения.Вставить("Наименование", ?(ПустаяСтрока(Наименование), АдресЭП, Наименование));
	
	КонтактнаяИнформация = Новый Структура;
	КонтактнаяИнформация.Вставить("Вид", ВидКонтактнойИнформации);
	КонтактнаяИнформация.Вставить("Представление", АдресЭП);
	
	ПараметрыСоздания = Новый Структура;
	ПараметрыСоздания.Вставить("ЗначенияЗаполнения",   ЗначенияЗаполнения);
	ПараметрыСоздания.Вставить("КонтактнаяИнформация", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(КонтактнаяИнформация));
	
	Возврат Справочники.КонтактныеЛица.СоздатьКонтактноеЛицо(ПараметрыСоздания);
	
КонецФункции

#КонецОбласти

#Область ЗаполнениеСписковЗначений

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораВремени(ПолеВводаФормы, Интервал = 3600)
	
	НачалоРабочегоДня      = '00010101000000';
	ОкончаниеРабочегоДня   = '00010101235959';
	
	СписокВремен = ПолеВводаФормы.СписокВыбора;
	СписокВремен.Очистить();
	
	ВремяСписка = НачалоРабочегоДня;
	Пока НачалоЧаса(ВремяСписка) <= НачалоЧаса(ОкончаниеРабочегоДня) Цикл
		Если НЕ ЗначениеЗаполнено(ВремяСписка) Тогда
			ПредставлениеВремени = "00:00";
		Иначе
			ПредставлениеВремени = Формат(ВремяСписка,"ДФ=ЧЧ:мм");
		КонецЕсли;
		
		СписокВремен.Добавить(ВремяСписка, ПредставлениеВремени);
		
		ВремяСписка = ВремяСписка + Интервал;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокДнейМесяца(ПолеВводаФормы)
	
	СписокДней = ПолеВводаФормы.СписокВыбора;
	СписокДней.Очистить();
	
	Для Инд = 1 По 31 Цикл
		СписокДней.Добавить(Инд);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОповещений

&НаКлиенте
Процедура ПослеНастройкиУчетнойЗаписиЭлектроннойПочты(УчетнаяЗаписьНастроена, Контекст) Экспорт
	
	Если УчетнаяЗаписьНастроена <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	ЗаполнитьУчетнуюЗаписьИОбновитьСвязанныеДанные(Объект.УчетнаяЗапись, ПолучателиРассылки);
	
	УстановитьВидимостьПредупреждения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьУчетнуюЗаписьИОбновитьСвязанныеДанные(УчетнаяЗапись, ПолучателиРассылки)
	
	УчетнаяЗапись = УчетнаяЗаписьДляОтправки();
	Если ПустаяСтрока(ПолучателиРассылки) Тогда
		ПолучателиРассылки = ПолучателиРассылкиПоУмолчанию(УчетнаяЗапись);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("УчетнаяЗаписьЭлектроннойПочты")) Тогда
		ОбщегоНазначенияБПВызовСервера.УстановитьЗначениеПоУмолчанию("УчетнаяЗаписьЭлектроннойПочты", УчетнаяЗапись);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
