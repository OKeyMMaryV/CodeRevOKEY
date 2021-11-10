﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "Организация, НачалоПериода, КонецПериода");
	
	СтатусыОпераций = Обработки.ПомощникРасчетаНалогаУСН.СтатусыОперацийИнтеграцияСБанком();
	
	Список.Параметры.УстановитьЗначениеПараметра("Организация", Организация);
	Список.Параметры.УстановитьЗначениеПараметра("НачалоПериода", НачалоПериода);
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериода", КонецПериода);
	Список.Параметры.УстановитьЗначениеПараметра("БанковскиеСчетаВРежимеИнтеграции",
		Справочники.НастройкиИнтеграцииСБанками.БанковскиеСчетаОрганизацииВРежимеИнтеграции(Организация));
	Список.Параметры.УстановитьЗначениеПараметра("СтатусОперацииПоСчетуВРежимеИнтеграции",
		СтатусыОпераций.ОперацияПоОсновномуБанковскомуСчету);
	Список.Параметры.УстановитьЗначениеПараметра("СтатусОперацииПоДругомуСчетуИлиНаличными",
		СтатусыОпераций.ОперацияПоДругомуСчетуИлиНаличными);
	
	Если Параметры.ПоказатьПредупреждения Тогда
		ВариантОтбораПредупрежденийПриЗагрузке = ВариантОтбораТребующиеПроверки();
	Иначе
		ВариантОтбораПредупрежденийПриЗагрузке = ВариантОтбораВсе();
	КонецЕсли;
	
	ПоказатьБаннерПредупрежденийПриЗагрузкеИУстановитьОтбор();
	
	УстановитьТекстЗаголовка();
	
	УстановитьУсловноеОформление();
	
	ОбновитьИтоги();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если (ИмяСобытия = "ОбновитьПоказателиРасчетаУСН" И Не ЗначениеЗаполнено(Параметр)
			Или ИмяСобытия = "ИзменениеЗаписиКУДиР")
		И Источник <> ЭтотОбъект Тогда
		
		Элементы.Список.Обновить();
		ОбновитьИтоги();
		
	ИначеЕсли ИмяСобытия = "ИзмененоПредупреждениеПриЗагрузкеВыписки" Тогда
		
		ПоказатьБаннерПредупрежденийПриЗагрузкеИУстановитьОтбор();
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВариантОтбораОшибокЗагрузкиПриИзменении(Элемент)
	
	УстановитьОтборПредупрежденийПриЗагрузке(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДанныеСтроки = ОбщегоНазначенияБПКлиент.ТекущиеДанныеДинамическогоСписка(Элементы.Список);
	
	Если ДанныеСтроки <> Неопределено Тогда
		ОткрытьОперацию(ДанныеСтроки.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ДанныеСтроки = ОбщегоНазначенияБПКлиент.ТекущиеДанныеДинамическогоСписка(Элементы.Список);
	
	ДоступностьКомандыУдалитьОперацию = (ДанныеСтроки <> Неопределено
		И ДанныеСтроки.СтатусДохода = СтатусыОпераций.ОперацияПоДругомуСчетуИлиНаличными);
	
	Элементы.УдалитьОперацию.Доступность = ДоступностьКомандыУдалитьОперацию;
	Элементы.СписокКонтекстноеМенюУдалитьОперацию.Доступность = ДоступностьКомандыУдалитьОперацию;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьОперацию(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Организация", Организация);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ПараметрыФормы.Вставить("НалоговыйПериод", КонецПериода);
	ПараметрыФормы.Вставить("ВидОперации", ВидОперацииЗаписиКУДиР());
	
	ОткрытьФорму("Документ.ЗаписьКУДиР.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОперацию(Команда)
	
	ДанныеСтроки = ОбщегоНазначенияБПКлиент.ТекущиеДанныеДинамическогоСписка(Элементы.Список);
	
	Если ДанныеСтроки <> Неопределено Тогда
		ОткрытьОперацию(ДанныеСтроки.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьОперацию(Команда)
	
	ДанныеСтроки = ОбщегоНазначенияБПКлиент.ТекущиеДанныеДинамическогоСписка(Элементы.Список);
	
	Если ДанныеСтроки <> Неопределено Тогда
		
		ТекстВопроса = СтрШаблон(НСтр("ru = 'Удалить %1 №%2 от %3?'"),
			ВидОперацииЗаписиКУДиР(),
			ДанныеСтроки.Номер,
			Формат(ДанныеСтроки.Дата, "ДЛФ=D"));
		
		ДополнительныеПараметры = Новый Структура("Ссылка", ДанныеСтроки.Ссылка);
		Оповещение = Новый ОписаниеОповещения("УдалитьОперациюЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьОперациюЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьДокумент(ДополнительныеПараметры.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьОперацию(Операция)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Операция);
	ПараметрыФормы.Вставить("НалоговыйПериод", КонецПериода);
	
	ОткрытьФорму(ИмяФормыДокумента(Операция), ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьДокумент(Ссылка)
	
	ДокументОбъект = Ссылка.ПолучитьОбъект();
	ДокументОбъект.УстановитьПометкуУдаления(Истина);
	
	Элементы.Список.Обновить();
	ОбновитьИтоги();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИтоги()
	
	ИтогиДинамическогоСписка = ОбщегоНазначенияБП.ИтогиДинамическогоСписка(Список, "Сумма,УменьшаетДоходы");
	ИтогиСумма = ИтогиДинамическогоСписка.Сумма;
	ИтогиУменьшаетДоходы = ИтогиДинамическогоСписка.УменьшаетДоходы;
	
КонецПроцедуры

&НаСервере
Функция УстановитьТекстЗаголовка()
	
	Заголовок = СтрШаблон(
		НСтр("ru = 'Возвраты покупателям за %1'"),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(НачалоПериода, КонецПериода, Истина));
	
КонецФункции

&НаСервереБезКонтекста
Функция ВидОперацииЗаписиКУДиР()
	
	Возврат Документы.ЗаписьКУДиР.ВидыОперацийОднострочнойФормы().ВозвратПокупателю;
	
КонецФункции

&НаСервереБезКонтекста
Функция ИмяФормыДокумента(Ссылка)
	
	Возврат СтрШаблон("Документ.%1.ФормаОбъекта", Ссылка.Метаданные().Имя);
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Строки с предупреждениями при загрузке
	
	УсловноеОформление.Элементы.Очистить();
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Список");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ЕстьПредупреждения", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.БанковскиеДокументыСПредупреждениямиПриЗагрузке);
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаПредупрежденийПриЗагрузке

&НаСервере
Процедура ПоказатьБаннерПредупрежденийПриЗагрузкеИУстановитьОтбор()
	
	ЕстьПредупреждения = ЕстьДокументыСПредупреждениямиПриЗагрузке(
		Организация, НачалоПериода, КонецПериода);
	
	Элементы.ГруппаПредупрежденияПриЗагрузкеИзКлиентБанка.Видимость = ЕстьПредупреждения;
	Если Не ЕстьПредупреждения Тогда
		ВариантОтбораПредупрежденийПриЗагрузке = ВариантОтбораВсе();
	КонецЕсли;
	
	УстановитьОтборПредупрежденийПриЗагрузке(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВариантОтбораВсе()
	
	Возврат "Все";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВариантОтбораТребующиеПроверки()
	
	Возврат "ТребующиеПроверки";
	
КонецФункции

&НаСервереБезКонтекста
Функция ЕстьДокументыСПредупреждениямиПриЗагрузке(Организация, НачалоПериода, КонецПериода)
	
	ПараметрыОтбораПредупреждений = РегистрыСведений.ПредупрежденияПриЗагрузкеВыписки.НовыеПараметрыОтбораПредупреждений();
	ПараметрыОтбораПредупреждений.Организация = Организация;
	ПараметрыОтбораПредупреждений.НачалоПериода = НачалоПериода;
	ПараметрыОтбораПредупреждений.КонецПериода = КонецПериода;
	ПараметрыОтбораПредупреждений.ТипДокументов = "СписаниеСРасчетногоСчета";
	
	Возврат РегистрыСведений.ПредупрежденияПриЗагрузкеВыписки.ЕстьПредупрежденияВСписке(ПараметрыОтбораПредупреждений);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПредупрежденийПриЗагрузке(Форма)
	
	Настройки = Форма.Список.КомпоновщикНастроек.Настройки;
	
	ИмяПоля = "Ссылка";
	
	Если Форма.ВариантОтбораПредупрежденийПриЗагрузке = ВариантОтбораТребующиеПроверки() Тогда
		
		ДокументыСПредупреждениямиПриЗагрузке = ДокументыСПредупреждениямиПриЗагрузке(
			Форма.Организация, Форма.НачалоПериода, Форма.КонецПериода);
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
			Настройки.Отбор,
			ИмяПоля);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Настройки.Отбор,
			ИмяПоля,
			ДокументыСПредупреждениямиПриЗагрузке,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			Истина);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
			Настройки.Отбор,
			ИмяПоля);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДокументыСПредупреждениямиПриЗагрузке(Организация, НачалоПериода, КонецПериода)
	
	ПараметрыОтбораПредупреждений = РегистрыСведений.ПредупрежденияПриЗагрузкеВыписки.НовыеПараметрыОтбораПредупреждений();
	ПараметрыОтбораПредупреждений.Организация = Организация;
	ПараметрыОтбораПредупреждений.НачалоПериода = НачалоПериода;
	ПараметрыОтбораПредупреждений.КонецПериода = КонецПериода;
	ПараметрыОтбораПредупреждений.ТипДокументов = "СписаниеСРасчетногоСчета";
	
	Возврат РегистрыСведений.ПредупрежденияПриЗагрузкеВыписки.ДокументыСПредупреждениями(ПараметрыОтбораПредупреждений);
	
КонецФункции

#КонецОбласти
