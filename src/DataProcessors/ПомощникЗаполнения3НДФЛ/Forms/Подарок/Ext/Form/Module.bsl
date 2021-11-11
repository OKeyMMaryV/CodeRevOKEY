﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СтруктураДоходовВычетов") 
		И ЗначениеЗаполнено(Параметры.СтруктураДоходовВычетов)
		И Параметры.СтруктураДоходовВычетов.Свойство("ДанныеФормы")
		И ЗначениеЗаполнено(Параметры.СтруктураДоходовВычетов.ДанныеФормы) Тогда
		ЗаполнитьФормуИзДанных(Параметры.СтруктураДоходовВычетов.ДанныеФормы);
	Иначе
		ЗаполнитьНовуюФорму();
	КонецЕсли;
	
	КодыВидовДоходовРФ = Отчеты.РегламентированныйОтчет3НДФЛ.КодыВидовДоходовРФ(Параметры.Декларация3НДФЛВыбраннаяФорма);
	
	Если Отчеты.РегламентированныйОтчет3НДФЛ.МожноНеУказыватьНаименованиеИсточникаДохода(Параметры.Декларация3НДФЛВыбраннаяФорма) Тогда
		Элементы.ВидКонтрагента.СписокВыбора.Добавить(Перечисления.ЮридическоеФизическоеЛицо.ПустаяСсылка(), НСтр("ru = 'Неизвестен'"));
	КонецЕсли;
	
	ПомощникЗаполнения3НДФЛ.ИсточникДоходовПриСозданииНаСервере(ЭтотОбъект, ЗначениеЗаполнено(ВидКонтрагента));
	УстановитьКлючСохраненияПоложенияОкна(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидКонтрагента = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо Тогда
		ПроверяемыеРеквизиты.Добавить("ИНН");
	КонецЕсли;
	
	ПомощникЗаполнения3НДФЛ.ПроверитьЗаполнениеРеквизитовИсточникаДоходов(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	ОрганизацииФормыДляОтчетности.ПроверитьКодПоОКТМОНаФорме(ОКТМО, "ОКТМО", Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидКонтрагентаПриИзменении(Элемент)
	
	// Очистим реквизиты, которые зависят от вида контрагента.
	Наименование = "";
	ФИО = "";
	ИНН = "";
	КПП = "";
	ОКТМО = "";
	
	ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Истина, Истина);
	ПомощникЗаполнения3НДФЛКлиентСервер.УстановитьВидимостьПолейКонтрагента(ЭтотОбъект, ЗначениеЗаполнено(ВидКонтрагента));
	УстановитьКлючСохраненияПоложенияОкна(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПоискаИНННаименованиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ПолеПоискаИНННаименование)
		И НЕ ЗначениеЗаполнено(ИНН) 
		И НЕ ЗначениеЗаполнено(Наименование) Тогда
		
		ПомощникЗаполнения3НДФЛКлиент.ЗаполнитьРеквизитыПоДаннымЕГР(ПолеПоискаИНННаименование, ОповещениеПослеЗаполненияПоИНН());
		ОтключитьЗаполнениеПоИНН = Истина;
		ПодключитьОбработчикОжидания("Подключаемый_ВключитьЗаполнениеПоИНН", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	ИНН = СокрП(ИНН);
	ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КПППриИзменении(Элемент)
	
	КПП = СокрП(КПП);
	ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Ложь, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаполнитьПоИНН(Команда)
	
	Если НЕ ЗначениеЗаполнено(ИНН) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Поле ""ИНН"" не заполнено'"));
		ТекущийЭлемент = Элементы.ИНН;
		Возврат;
	ИначеЕсли НЕ ОшибокПоИННнет Тогда
		ПоказатьПредупреждение(, Строка(РезультатПроверкиИНН));
		ТекущийЭлемент = Элементы.ИНН;
		Возврат;
	КонецЕсли;
	
	ПомощникЗаполнения3НДФЛКлиент.ВыполнитьЗаполнениеРеквизитовПоИНН(ИНН, ОповещениеПослеЗаполненияПоИНН());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоДаннымЕГР(Команда)
	
	ПомощникЗаполнения3НДФЛКлиент.ЗаполнитьРеквизитыПоДаннымЕГР(ПолеПоискаИНННаименование, ОповещениеПослеЗаполненияПоИНН());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоНаименованию(Команда)
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Поле ""Наименование"" не заполнено'"));
		ТекущийЭлемент = Элементы.Наименование;
	Иначе
		ПомощникЗаполнения3НДФЛКлиент.ВыполнитьЗаполнениеРеквизитовПоНаименованию(Наименование, ОповещениеПослеЗаполненияПоИНН());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураРезультата = Новый Структура;
	
	Если ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо") Тогда
		Информация = СтрШаблон(НСтр("ru = 'Подарок от %1'"), Наименование);
	ИначеЕсли ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо") Тогда
		Информация = СтрШаблон(НСтр("ru = 'Подарок от %1'"), ФИО);
	Иначе
		Информация = НСтр("ru = 'Подарок'");
	КонецЕсли;
	
	// Информация для формы помощника.
	СтруктураРезультата.Вставить("Вид", ПредопределенноеЗначение("Перечисление.ИсточникиДоходовФизическихЛиц.Подарок"));
	СтруктураРезультата.Вставить("Информация", Информация);
	СтруктураРезультата.Вставить("СуммаДохода", СуммаДохода);
	
	// Данные формы для восстановления.
	СтруктураРезультата.Вставить("ДанныеФормы", СохранитьДанныеФормы());
	
	// Данные для отчетности.
	СтруктураРезультата.Вставить("ДанныеДекларации", СохранитьДанныеДекларации());
	
	Закрыть(СтруктураРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.ИНН.ОтметкаНезаполненного = Ложь;
	Форма.Элементы.ИНН.АвтоОтметкаНезаполненного =
		(Форма.ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо"));
	
	Если (Форма.ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо")) Тогда
		Форма.Элементы.ИНН.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
	Иначе
		Форма.Элементы.ИНН.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуИзДанных(ДанныеФормы)
	
	Для Каждого ИмяРеквизита Из МассивРеквизитовФормы() Цикл
		ДанныеФормы.Свойство(ИмяРеквизита, ЭтотОбъект[ИмяРеквизита]);
	КонецЦикла;
	
	ЗаполнениеРеквизитовПлашкой = НЕ ЗначениеЗаполнено(Наименование);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНовуюФорму()
	
	ВидКонтрагента = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
	ЗаполнениеРеквизитовПлашкой = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьКлючСохраненияПоложенияОкна(Форма)
	
	ПрефиксКлючаСохранения = "";
	
	ПомощникЗаполнения3НДФЛКлиентСервер.УстановитьКлючСохраненияПоложенияОкна(Форма, ПрефиксКлючаСохранения);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МассивРеквизитовФормы()
	
	Массив = Новый Массив;
	Массив.Добавить("СуммаДохода");
	Массив.Добавить("ВидКонтрагента");
	Массив.Добавить("ФИО");
	Массив.Добавить("Наименование");
	Массив.Добавить("ИНН");
	Массив.Добавить("КПП");
	Массив.Добавить("ОКТМО");
	
	Возврат Массив;
	
КонецФункции

&НаКлиенте
Функция СохранитьДанныеФормы()
	
	ДанныеФормы = Новый Структура;
	Для Каждого ИмяРеквизита Из МассивРеквизитовФормы() Цикл
		ДанныеФормы.Вставить(ИмяРеквизита, ЭтотОбъект[ИмяРеквизита]);
	КонецЦикла;
	
	Возврат ДанныеФормы;
	
КонецФункции

&НаКлиенте
Функция СохранитьДанныеДекларации()
	
	Если ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо") Тогда
		НаименованиеИсточникаДохода = ФИО;
	ИначеЕсли ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо") Тогда
		НаименованиеИсточникаДохода = Наименование;
	Иначе
		НаименованиеИсточникаДохода = НСтр("ru = 'Подарок'");
	КонецЕсли;
	
	ДанныеДекларации = Новый Структура;
	ДанныеДекларации.Вставить("КодВидаДохода", КодыВидовДоходовРФ.Подарок);
	ДанныеДекларации.Вставить("Наименование", НаименованиеИсточникаДохода);
	ДанныеДекларации.Вставить("ИНН", ИНН);
	ДанныеДекларации.Вставить("КПП", КПП);
	ДанныеДекларации.Вставить("ОКТМО", ОКТМО);
	ДанныеДекларации.Вставить("СуммаДохода", СуммаДохода);
	
	Возврат ДанныеДекларации;
	
КонецФункции

#Область ЗаполнениеРеквизитовКонтрагента

&НаКлиенте
Функция ОповещениеПослеЗаполненияПоИНН()
	
	Возврат Новый ОписаниеОповещения("ПослеЗаполненияПоИНН", ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ПослеЗаполненияПоИНН(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Результат);
		ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Истина, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВключитьЗаполнениеПоИНН()
	
	ОтключитьЗаполнениеПоИНН = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
