﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(Отчет, Параметры);
	СформироватьПриОткрытии = Параметры.СформироватьПриОткрытии;
	ТолькоНДС               = Параметры.ТолькоНДС;
	
	Если НЕ ЗначениеЗаполнено(Отчет.КонецПериода) Тогда
		Отчет.КонецПериода  = КонецКвартала(ОбщегоНазначения.ТекущаяДатаПользователя());
		ИзменитьПериод(Отчет.КонецПериода, -3);
	КонецЕсли;
	
	ПредставлениеПериода = ПолучитьПредставлениеПериода(Отчет.КонецПериода);
	
	Если НЕ ЗначениеЗаполнено(Отчет.Организация) Тогда
		Отчет.Организация   = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	ИспользуетсяНесколькоОрганизаций = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбщегоНазначенияБПКлиент.ПроверитьНаличиеОрганизаций();
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	ИБФайловая = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = НЕ ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	
	Если ПодключитьОбработчикОжидания Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		УстановитьСостояниеПоляТабличногоДокумента(Элементы.РезультатОтчета, "ФормированиеОтчета");
	ИначеЕсли СформироватьПриОткрытии Тогда 
		СформироватьОтчетНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	Если Отчет.РежимРасшифровки Тогда
		Возврат;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки, ИспользуютсяСтандартныеНастройки)
	
	Если ИспользуютсяСтандартныеНастройки Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отчет.РежимРасшифровки Тогда
		БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	КонецЕсли;
	
	Если Год(Отчет.КонецПериода) < 2013 Тогда
		Отчет.КонецПериода = КонецГода(Дата(2013, 1, 1));
	КонецЕсли;
	
	Если (Месяц(Отчет.НачалоПериода) = 3) И (Год(Отчет.КонецПериода) = 2013) Тогда
		Элементы.УменьшитьПериод.Доступность = Ложь;
	КонецЕсли;
	
	НовыйПериод = Отчет.КонецПериода;
	ИзменитьПериод(НовыйПериод, 0);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода, НарастающимИтогом", 
		Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаКвартал", ПараметрыВыбора, Элементы.ПредставлениеПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Год(ВыбранноеЗначение.КонецПериода) < 2013 Тогда
		ТекстСообщения = Нстр("ru = 'Период проверки не может быть раньше 2013 г.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ПредставлениеПериода");
		Возврат;
	КонецЕсли;
	
	Если (Месяц(ВыбранноеЗначение.КонецПериода) = 3) И (Год(ВыбранноеЗначение.КонецПериода) = 2013) Тогда
		Элементы.УменьшитьПериод.Доступность = Ложь;
	Иначе
		Элементы.УменьшитьПериод.Доступность = Истина;
	КонецЕсли;
	
	ИзменитьПериод(ВыбранноеЗначение.КонецПериода);
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УстановитьСостояниеПоляТабличногоДокумента(Элементы.РезультатОтчета, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УстановитьСостояниеПоляТабличногоДокумента(Элементы.РезультатОтчета, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПоляТабличногоДокумента

&НаКлиенте
Процедура РезультатОтчетаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если Расшифровка.Свойство("СсылкаНаКритерий") Тогда
			
			ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(Расшифровка.СсылкаНаКритерий);
			
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
				СобытиеЖурналаРегистрации(), "Информация","ОценкаРискаНалоговойПроверки." + Формат(Отчет.КонецПериода,"ДФ=yyyy-MM-dd")
				+ ".Расшифровка.СсылкаНаКритерий" , , Истина);
				
		ИначеЕсли Расшифровка.Свойство("ИзменитьБезопаснуюДолюВычета") Тогда
				
			КлючЗаписи = ПолучитьДанныеНастроекНДС(Отчет.Организация, Отчет.КонецПериода);
			Если КлючЗаписи <> Неопределено Тогда
				ПараметрыОткрытия = Новый Структура("Ключ, ПараметрыОткрытия",
					КлючЗаписи,
					Новый Структура("АктивныйЭлемент", "БезопаснаяДоляВычета"));
				ОткрытьФорму("РегистрСведений.НастройкиУчетаНДС.ФормаЗаписи", ПараметрыОткрытия, ЭтаФорма, "");
			КонецЕсли;
				
		ИначеЕсли Расшифровка.Свойство("ПриложениеПриказа") Тогда
			
			ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(Расшифровка.ПриложениеПриказа);
			
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
				СобытиеЖурналаРегистрации(), "Информация", "ОценкаРискаНалоговойПроверки." + Формат(Отчет.КонецПериода,"ДФ=yyyy-MM-dd")
				+ ".Расшифровка.ПриложениеПриказа", , Истина);
				
		ИначеЕсли Расшифровка.Свойство("Вопрос") Тогда
			
			Оповещение = Новый ОписаниеОповещения("ВыполнитьПослеЗакрытияДиалога", ЭтаФорма, Расшифровка);
			ТекстВопроса = "Создать " + Расшифровка.ПредставлениеОтчета + " ?";
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(КодВозвратаДиалога.Да);
			Кнопки.Добавить(КодВозвратаДиалога.Отмена);
			КнопкаПоУмолчанию = КодВозвратаДиалога.Да;
			ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, ,КнопкаПоУмолчанию);
			
		ИначеЕсли Расшифровка.Свойство("ИсточникОтчета") Тогда
			
			ОткрытьФормуНовогоОтчета(Расшифровка);
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Расшифровка) = Тип("Строка") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если Расшифровка = "КодОКВЭД" 
			ИЛИ Расшифровка = "Адрес" Тогда
			
			АдресНавигационнойСсылки = ПолучитьНавигационнуюСсылку(Отчет.Организация);
			ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(АдресНавигационнойСсылки);
			
		ИначеЕсли Расшифровка = "УчетнаяПолитика" Тогда
			
			ПараметрыФормы = Новый Структура;
			Отбор = Новый Структура("Организация", Отчет.Организация);
			ПараметрыФормы.Вставить("Отбор", Отбор);
			ОткрытьФорму("РегистрСведений.НастройкиСистемыНалогообложения.ФормаСписка", ПараметрыФормы, ЭтаФорма);
			
		КонецЕсли;
	Иначе
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			СобытиеЖурналаРегистрации(), "Информация", "ОценкаРискаНалоговойПроверки." + Формат(Отчет.КонецПериода,"ДФ=yyyy-MM-dd") 
			+ ".Расшифровка.РегламентированныйОтчет", , Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УменьшитьПериод(Команда)
	
	Если (Месяц(Отчет.КонецПериода) - 3 = 3) И (Год(Отчет.КонецПериода) = 2013) Тогда
		Элементы.УменьшитьПериод.Доступность = Ложь;
	КонецЕсли;
	
	НовыйПериод = Отчет.КонецПериода;
	ИзменитьПериод(НовыйПериод, -3);
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УстановитьСостояниеПоляТабличногоДокумента(Элементы.РезультатОтчета, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УвеличитьПериод(Команда)
	
	НовыйПериод = Отчет.КонецПериода;
	ИзменитьПериод(НовыйПериод, 3);
	
	Если НЕ Элементы.УменьшитьПериод.Доступность Тогда
		Элементы.УменьшитьПериод.Доступность = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УстановитьСостояниеПоляТабличногоДокумента(Элементы.РезультатОтчета, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	СформироватьОтчетНаКлиенте();
	
КонецПроцедуры
	
&НаКлиенте
Процедура СформироватьОтчетНаКлиенте()
	
	Если НЕ ЗначениеЗаполнено(Отчет.Организация) И НЕ ИспользуетсяНесколькоОрганизаций Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнены реквизиты организации.'"));
		Возврат;
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если НЕ РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		УстановитьСостояниеПоляТабличногоДокумента(Элементы.РезультатОтчета, 
			"ФормированиеОтчета");
	КонецЕсли;
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ФормированиеОтчетаОценкаРискаНалоговойПроверки");
	
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
		СобытиеЖурналаРегистрации(), "Информация", "ОценкаРискаНалоговойПроверки." + Формат(Отчет.КонецПериода,"ДФ=yyyy-MM-dd") 
		+ ".Формирование", , Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	Если ЕстьРезультатДляПечати Тогда
		ВывестиПечатнуюФорму();
	Иначе
		ТекстСообщения = Нстр("ru = 'Нет информации для вывода на печать.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиПечатнуюФорму()
	
	РезультатДляПечати.ТолькоПросмотр = Истина;
	РезультатДляПечати.АвтоМасштаб = Истина;
	РезультатДляПечати.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	РезультатДляПечати.ОтображатьЗаголовки = Ложь;
	РезультатДляПечати.ОтображатьСетку = Ложь;
	
	ИдентификаторПечатнойФормы = "ПечатнаяФорма";
	НазваниеПечатнойФормы = НСтр("ru = 'Оценка риска выездной налоговой проверки'");
	
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(ИдентификаторПечатнойФормы);
	ПечатнаяФорма = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, ИдентификаторПечатнойФормы);
	ПечатнаяФорма.СинонимМакета = НазваниеПечатнойФормы;
	ПечатнаяФорма.ТабличныйДокумент = РезультатДляПечати;
	ПечатнаяФорма.ИмяФайлаПечатнойФормы = НазваниеПечатнойФормы;
	
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм);
	
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
		СобытиеЖурналаРегистрации(), "Информация", "ОценкаРискаНалоговойПроверки." + Формат(Отчет.КонецПериода,"ДФ=yyyy-MM-dd") 
		+ ".Печать", , Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанныеНаСервере();
			УстановитьСостояниеПоляТабличногоДокумента(Элементы.РезультатОтчета, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		УстановитьСостояниеПоляТабличногоДокумента(Элементы.РезультатОтчета, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеНаСервере()
	
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если ТипЗнч(РезультатВыполнения) = Тип("Структура") Тогда
		Результат = РезультатВыполнения.Результат;
		ЕстьРезультатДляПечати = РезультатВыполнения.Свойство("РезультатДляПечати", РезультатДляПечати);
	КонецЕсли;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.РезультатОтчета, "НеИспользовать");
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьПериод(НовыйПериод, КоличествоМесяцев = 0)
	
	КоличествоЛет = 0;
	МесяцПериода = Месяц(НовыйПериод);
	
	Если (КоличествоМесяцев = -3) И (МесяцПериода = 3) Тогда
		МесяцПериода = 12;
		КоличествоЛет = -1;
	ИначеЕсли (КоличествоМесяцев = 3) И (МесяцПериода = 12) Тогда
		МесяцПериода = 3;
		КоличествоЛет = 1;
	ИначеЕсли (КоличествоМесяцев <> 0) Тогда
		МесяцПериода = МесяцПериода + КоличествоМесяцев;
	КонецЕсли;
	
	Отчет.КонецПериода = КонецКвартала(Дата(Год(НовыйПериод) + КоличествоЛет, МесяцПериода, 1));
	Отчет.НачалоПериода = НачалоГода(Отчет.КонецПериода);
	ПредставлениеПериода = ПолучитьПредставлениеПериода(Отчет.КонецПериода);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПредставлениеПериода(КонецПериода)
	
	НомерКвартала = Месяц(КонецПериода)/3;
	ГодОтчета = Формат(Год(КонецПериода), "ЧГ=");
	
	Шаблон = НСтр("ru='%1 %2 %3'");
	Если НомерКвартала = 1 Тогда
		ПредставлениеПериода = СтрШаблон(Шаблон, НСтр("ru='1 квартал'"), ГодОтчета, НСтр("ru='года'"));
	ИначеЕсли НомерКвартала = 2 Тогда
		ПредставлениеПериода = СтрШаблон(Шаблон, НСтр("ru='1 полугодие'"), ГодОтчета, НСтр("ru='года'"));
	ИначеЕсли НомерКвартала = 3 Тогда
		ПредставлениеПериода = СтрШаблон(Шаблон, НСтр("ru='9 месяцев'"), ГодОтчета, НСтр("ru='года'"));
	ИначеЕсли НомерКвартала = 4 Тогда
		ПредставлениеПериода = СтрШаблон(Шаблон, "", ГодОтчета, НСтр("ru='год'"));
	КонецЕсли;
	ПредставлениеПериода = СокрЛП(ПредставлениеПериода);
	
	Возврат ПредставлениеПериода
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	ИдентификаторЗадания = Неопределено;
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Отчеты.ОценкаРискаНалоговойПроверки.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Отчеты.ОценкаРискаНалоговойПроверки.СформироватьОтчет", 
			ПараметрыОтчета, 
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
			
		АдресХранилища = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанныеНаСервере();
	КонецЕсли;
		
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчетаНаСервере()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация",             Отчет.Организация);
	ПараметрыОтчета.Вставить("НачалоПериода",           Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода",            Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("ТолькоНДС",               ТолькоНДС);
	
	ФормироватьДекларациюНДСВПомощнике = Обработки.ПомощникРасчетаНДС.ФормироватьДекларациюВПомощнике(
		Отчет.Организация, Отчет.НачалоПериода);

	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПослеЗакрытияДиалога(Ответ, Расшифровка) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОткрытьФормуНовогоОтчета(Расшифровка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНовогоОтчета(Расшифровка)
	
	Если Расшифровка.ИсточникОтчета = "РегламентированныйОтчетНДС" 
	   И ФормироватьДекларациюНДСВПомощнике Тогда
		
		ПараметрыПомощника = Новый Структура;
		ПараметрыПомощника.Вставить("Организация",      Отчет.Организация);
		ПараметрыПомощника.Вставить("ПериодСобытия",    Расшифровка.НачалоПериода);
		ПараметрыПомощника.Вставить("КонтекстныйВызов", Ложь);
		ПараметрыПомощника.Вставить("ИсточникВызова",   "ОткрытиеПомощникаНДСОценкаРискаНалоговойПроверки");
		
		ИмяФормыПомощника = "Обработка.ПомощникРасчетаНДС.Форма";
		
		ОткрытьФорму(ИмяФормыПомощника, ПараметрыПомощника);
		
	Иначе
		
		ИсточникОтчета = Расшифровка.ИсточникОтчета;
		НастройкиФормы = Новый Структура;
		НастройкиФормы.Вставить("Организация", Отчет.Организация);
		НастройкиФормы.Вставить("мДатаНачалаПериодаОтчета", Расшифровка.НачалоПериода);
		НастройкиФормы.Вставить("мДатаКонцаПериодаОтчета", Расшифровка.КонецПериода);
		
		ИмяФормыРеглОтчета = "Отчет." + ИсточникОтчета + ".Форма.ОсновнаяФорма";
		
		ОткрытьФорму(ИмяФормыРеглОтчета, НастройкиФормы, ЭтаФорма, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			СобытиеЖурналаРегистрации(), "Информация", "ОценкаРискаНалоговойПроверки."
			+ Формат(Отчет.КонецПериода,"ДФ=yyyy-MM-dd")
			+ ".СозданиеОтчета." + Расшифровка.ИсточникОтчета, , Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСостояниеПоляТабличногоДокумента(ПолеТабличногоДокумента, Состояние = "НеИспользовать")
	
	Если ТипЗнч(ПолеТабличногоДокумента) = Тип("ПолеФормы") 
		И ПолеТабличногоДокумента.Вид = ВидПоляФормы.ПолеТабличногоДокумента Тогда
		ОтображениеСостояния = ПолеТабличногоДокумента.ОтображениеСостояния;
		Если ВРег(Состояние) = "НЕИСПОЛЬЗОВАТЬ" Тогда
			ОтображениеСостояния.Видимость                      = Ложь;
			ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
			ОтображениеСостояния.Картинка                       = Новый Картинка;
			ОтображениеСостояния.Текст                          = "";
		ИначеЕсли ВРег(Состояние) = "НЕАКТУАЛЬНОСТЬ" Тогда
			ОтображениеСостояния.Видимость                      = Истина;
			ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
			ОтображениеСостояния.Картинка                       = Новый Картинка;
			ОтображениеСостояния.Текст                          = НСтр("ru = 'Отчет не сформирован. Нажмите ""Выполнить проверку"" для получения отчета.'");;
		ИначеЕсли ВРег(Состояние) = "ФОРМИРОВАНИЕОТЧЕТА" Тогда  
			ОтображениеСостояния.Видимость                      = Истина;
			ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
			ОтображениеСостояния.Картинка                       = БиблиотекаКартинок.ДлительнаяОперация48;
			ОтображениеСостояния.Текст                          = НСтр("ru = 'Отчет формируется...'");
		Иначе
			ВызватьИсключение(НСтр("ru = 'Недопустимое значение параметра (параметр номер ''2'')'"));
		КонецЕсли;
	Иначе
		ВызватьИсключение(НСтр("ru = 'Недопустимое значение параметра (параметр номер ''1'')'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СобытиеЖурналаРегистрации()

	Возврат НСтр("ru = 'Оценка риска налоговой проверки'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка());

КонецФункции 

&НаСервереБезКонтекста
Функция ПолучитьДанныеНастроекНДС(Организация, Период)

	Выборка = РегистрыСведений.НастройкиУчетаНДС.Выбрать(, Период,
		Новый Структура("Организация", Организация), "Убыв");
	Если Выборка.Следующий() Тогда
		Отбор = Новый Структура("Период, Организация", Выборка.Период, Выборка.Организация);
		Возврат РегистрыСведений.НастройкиУчетаНДС.СоздатьКлючЗаписи(Отбор);
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

#КонецОбласти


