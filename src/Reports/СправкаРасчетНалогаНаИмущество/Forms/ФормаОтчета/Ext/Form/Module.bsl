﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура УстановитьУсловноеОформление()

	// ГруппировкаИспользование, ГруппировкаПоле, ГруппировкаТипГруппировки

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ГруппировкаИспользование");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ГруппировкаПоле");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ГруппировкаТипГруппировки");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Отчет.Группировка.Предопределенная", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                      , Отчет.Организация);
	ПараметрыОтчета.Вставить("Период"                           , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("ВключатьОбособленныеПодразделения", Ложь);
	
	ПараметрыОтчета.Вставить("Группировка"                      , Отчет.Группировка.Выгрузить());
	ПараметрыОтчета.Вставить("РежимРасшифровки"                 , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления"                  , МакетОформления);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтотОбъект));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	
	ПараметрыОтчета.Вставить("ВыводитьЕдиницуИзмерения"         , ВыводитьЕдиницуИзмерения);
	ПараметрыОтчета.Вставить("ОтветственноеЛицо"                , ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.ОтветственныйЗаНалоговыеРегистры"));
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = "Справка-расчет налога на имущество" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
		Отчет.НачалоПериода, КонецДня(Отчет.КонецПериода));
	
	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Отчет.Организация);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Параметры");
	СписокПолей.Добавить("Ресурсы");
	СписокПолей.Добавить("Группировки");
	СписокПолей.Добавить("Организация");
	СписокПолей.Добавить("Подразделение");
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	Отчет.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки              = "";
	Отчет.КомпоновщикНастроек.Настройки.Порядок.ИдентификаторПользовательскойНастройки            = "";
	Отчет.КомпоновщикНастроек.Настройки.УсловноеОформление.ИдентификаторПользовательскойНастройки = "";
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет",
			ПараметрыОтчета,
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтотОбъект));
		
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьДоступностьКнопкиСохранитьРегистр(Форма)
	
	КнопкаСохранитьРегистрУчетаИПодписатьЭЦП  = Форма.Элементы.Найти("СохранитьРегистрУчетаИПодписатьЭЦП");
	КнопкаСохранитьРегистрБухгалтерскогоУчета = Форма.Элементы.Найти("СохранитьРегистрБухгалтерскогоУчета");
	Если КнопкаСохранитьРегистрУчетаИПодписатьЭЦП <> Неопределено И КнопкаСохранитьРегистрБухгалтерскогоУчета <> Неопределено Тогда
		Форма.Элементы.СохранитьРегистрБухгалтерскогоУчета.Доступность = Истина;
		Форма.Элементы.СохранитьРегистрУчетаИПодписатьЭЦП.Доступность  = Истина;
		Форма.Элементы.СохранитьРегистрБухгалтерскогоУчетаВсеДействия.Доступность = Истина;
		Форма.Элементы.СохранитьРегистрУчетаИПодписатьЭЦПВсеДействия.Доступность  = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Отчет    = Форма.Отчет;
	Элементы = Форма.Элементы;
	
	ИзменитьДоступностьКнопкиСохранитьРегистр(Форма);
	
	Форма.Период = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
		Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки) Экспорт
	
	Если ЗаполняемыеНастройки.Свойство("Группировка")
		И ЗаполняемыеНастройки.Группировка Тогда
		
		Отчет.Группировка.Очистить();
		
		Строка = Отчет.Группировка.Добавить();
		Строка.Поле             = "ИФНС";
		Строка.Представление    = "ИФНС";
		Строка.ТипГруппировки   = 0;
		Строка.Использование    = Ложь;
		
		Строка = Отчет.Группировка.Добавить();
		Строка.Поле             = "КодПоОКТМО";
		Строка.Представление    = "Код по ОКТМО";
		Строка.ТипГруппировки   = 0;
		Строка.Использование    = Ложь;
		
		Строка = Отчет.Группировка.Добавить();
		Строка.Поле             = "ВидИмущества";
		Строка.Представление    = "Код вида имущества";
		Строка.ТипГруппировки   = 0;
		Строка.Использование    = Ложь;
		
		Строка = Отчет.Группировка.Добавить();
		Строка.Поле             = "НалоговаяЛьгота";
		Строка.Представление    = "Код налоговой льготы";
		Строка.ТипГруппировки   = 0;
		Строка.Использование    = Ложь;
		
		Строка = Отчет.Группировка.Добавить();
		Строка.Поле             = "ОсновноеСредство";
		Строка.Представление    = "Основное средство";
		Строка.ТипГруппировки   = 0;
		Строка.Использование    = Истина;
		Строка.Предопределенная = Истина;
		
		ГруппировкиПроинициализированы = Истина;
		
	Иначе
		
		ИнициализироватьГруппировки();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат           = РезультатВыполнения.Результат;
	ДанныеРасшифровки   = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора() Экспорт
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Дата"              , Отчет.КонецПериода);
	СписокПараметров.Вставить("Номенклатура"      , Неопределено);
	СписокПараметров.Вставить("Склад"             , Неопределено);
	СписокПараметров.Вставить("Организация"       , Отчет.Организация);
	СписокПараметров.Вставить("Контрагент"        , Неопределено);
	СписокПараметров.Вставить("ДоговорКонтрагента", Неопределено);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки()
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	Элементы.РазделыОтчета.ТекущаяСтраница  = Элементы.Отчет;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода, КонецПериода");
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодОтчета()
	
	// Для этого отчета период "квартал нарастающим итогом"
	ВидПериода = Перечисления.ДоступныеПериодыОтчета.Квартал;
	
	Если КонецДня(Отчет.КонецПериода) <> КонецКвартала(Отчет.КонецПериода) Тогда
		Отчет.КонецПериода = КонецКвартала(Отчет.КонецПериода);
	КонецЕсли;
	
	Отчет.НачалоПериода = НачалоГода(Отчет.КонецПериода);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредопределенныеГруппировки(Таблица)
	
	Структура = Таблица.Строки;
	Пока Структура.Количество() > 0 Цикл
		Если Структура[0].ПоляГруппировки.Элементы.Количество() > 0 Тогда
			Если Структура[0].РежимОтображения <> РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
				Строка = Отчет.Группировка.Добавить();
				Строка.Поле             = Структура[0].ПоляГруппировки.Элементы[0].Поле;
				Строка.Представление    = Структура[0].ПредставлениеПользовательскойНастройки;
				Строка.ТипГруппировки   = Структура[0].ПоляГруппировки.Элементы[0].ТипГруппировки;
				Строка.Использование    = Структура[0].Использование;
				Строка.Предопределенная = Строка.Поле = "ОсновноеСредство";
			КонецЕсли;
		КонецЕсли;
		
		Структура = Структура[0].Структура;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьГруппировки()
	
	Отчет.Группировка.Очистить();
	
	Схема = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
	Настройки = Схема.ВариантыНастроек.Найти(ЭтотОбъект.КлючТекущегоВарианта);
	
	Если Настройки <> Неопределено Тогда
		ТаблицаКомпоновкиДанных = Настройки.Настройки.Структура[0].Структура[0];
		ЗаполнитьПредопределенныеГруппировки(ТаблицаКомпоновкиДанных);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	Если Не ГруппировкиПроинициализированы Тогда 
		ИнициализироватьГруппировки();
	КонецЕсли;
	
	УстановитьПериодОтчета();
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	УправлениеФормой(ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	ИБФайловая = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	Если ПодключитьОбработчикОжидания Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИСформировать(ПараметрыОтчета) Экспорт
	
	Если ТипЗнч(ПараметрыОтчета) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Отчет, ПараметрыОтчета);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыОтчета);
	КонецЕсли;
	
	Отчет.НачалоПериода = НачалоГода(Отчет.КонецПериода);
	Отчет.КонецПериода  = КонецКвартала(Отчет.КонецПериода);
	
	Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
	Отчет.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Очистить();
	
	ПериодПриИзменении(Элементы.Период);
	СформироватьОтчетНаСервере();
	
	Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ВариантМодифицирован                    = Ложь;
	ПользовательскиеНастройкиМодифицированы = НЕ Отчет.РежимРасшифровки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки, ИспользуютсяСтандартныеНастройки)
	
	Если ИспользуютсяСтандартныеНастройки Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отчет.РежимРасшифровки Тогда
		БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
		УстановитьПериодОтчета();
		ОбновитьТекстЗаголовка(ЭтотОбъект);
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, Элементы.Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииПодключаемый");
	
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ ТАБЛИЧНОГО ДОКУМЕНТА

&НаКлиенте
Процедура РезультатПриАктивизации(Элемент)
	
	БухгалтерскиеОтчетыКлиент.НачатьРасчетСуммыВыделенныхЯчеек(
		Элементы.Результат,
		ЭтотОбъект,
		"Подключаемый_РезультатПриАктивизацииПодключаемый");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если НЕ РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе
		СкрытьНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	СкрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ОткрытьНастройки();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ ГРУППЫ РЕГИСТРЫ УЧЕТА

&НаКлиенте
Процедура СохранитьРегистрУчета(Команда)
	
	РегистрыУчетаКлиент.СохранитьРегистрУчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьРегистрУчетаИПодписатьЭЦП(Команда)
	
	РегистрыУчетаКлиент.СохранитьРегистрУчета(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАрхивРегистровУчета(Команда)
	
	РегистрыУчетаКлиент.ОткрытьАрхивРегистровУчета(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ВыборПериодаКлиент.ПериодПриИзменении(Элемент, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	Период = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
		Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода, ВидПериода, НарастающимИтогом",
		НачалоГода(Отчет.КонецПериода), КонецДня(Отчет.КонецПериода), ВидПериода, Истина);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаКвартал", ПараметрыВыбора, Элементы.Период,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодОбработкаВыбора(
		Элемент, ВыбранноеЗначение, СтандартнаяОбработка,
		ВидПериода, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
		
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка,
		ВидПериода, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка,
		ВидПериода, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтотОбъект, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ПОКАЗАТЕЛИ

&НаКлиенте
Процедура ПереключательПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	ИзменитьДоступностьКнопкиСохранитьРегистр(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОТБОРЫ

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередУдалением(Элемент, Отказ)
	Отказ = Элемент.ТекущиеДанные.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОФОРМЛЕНИЕ

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЕдиницуИзмеренияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ГРУППИРОВКА

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		Если НЕ СтрокаТаблицы.Предопределенная Тогда
			СтрокаТаблицы.Использование = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		Если НЕ СтрокаТаблицы.Предопределенная Тогда
			СтрокаТаблицы.Использование = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьГруппировки(Команда)
	
	ИнициализироватьГруппировки();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)
	
	// Отменим перемещение предопределенной группировки
	КоличествоГруппировок = Отчет.Группировка.Количество();
	Если НЕ Отчет.Группировка[КоличествоГруппировок - 1].Предопределенная Тогда
		Отчет.Группировка.Сдвинуть(КоличествоГруппировок - 1, -1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = НЕ Элемент.ТекущиеДанные.Предопределенная;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры
