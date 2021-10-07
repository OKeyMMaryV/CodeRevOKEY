﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбменДанными

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Ложь;
	
	Настройки.НазначениеПланаОбмена = "РИББезФильтра";
	
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	ОписаниеВарианта.ИмяКонфигурацииКорреспондента = Метаданные.Имя;
	
	КраткаяИнформацияПоОбмену = НСтр("ru = 'Распределенная информационная база представляет собой иерархическую структуру, состоящую из отдельных информационных 
	|баз системы «1С:Предприятие» — узлов распределенной информационной базы, между которыми организована синхронизация 
	|конфигурации и данных. Главной особенностью распределенных информационных баз является передача изменений 
	|конфигурации в подчиненные узлы.'");
	КраткаяИнформацияПоОбмену = СтрЗаменить(КраткаяИнформацияПоОбмену, Символы.ПС, "");
	
	ОписаниеВарианта.КраткаяИнформацияПоОбмену   = КраткаяИнформацияПоОбмену;
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = "ПланОбмена.бит_Полный.Форма.ПодробнаяИнформация";
	
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
	
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = НСтр("ru = 'Настройки обмена распределенной информационной базы'");
	
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Распределенная информационная база'");
	
	ОписаниеВарианта.ИмяФормыСозданияНачальногоОбраза = "ОбщаяФорма.СозданиеНачальногоОбразаСФайлами";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбменДанными

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("РегистрироватьИзменения");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗарегистрироватьДополнительныеФайлыРегламентированныхОтчетов(Параметры) Экспорт
	
	Если НЕ ОбщегоНазначения.РазделениеВключено() Тогда
		
		Запрос = Новый Запрос();
		Запрос.Параметры.Вставить("ЭтотУзел", ПланыОбмена.бит_Полный.ЭтотУзел());
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПланОбменаРИБ.Ссылка
		|ИЗ
		|	ПланОбмена.бит_Полный КАК ПланОбменаРИБ
		|ГДЕ
		|	ПланОбменаРИБ.Ссылка <> &ЭтотУзел";
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Параметры.ОбработкаЗавершена = Истина;
			Возврат;
		КонецЕсли;
		МассивУзлов = Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Метаданные.РегистрыСведений.ДополнительныеФайлыРегламентированныхОтчетов);
		
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

Процедура ЗарегистрироватьПлановыеНачисленияИПредставленияОснованийУвольнения(Параметры) Экспорт
	
	Если НЕ ОбщегоНазначения.РазделениеВключено()
		И ПланыОбмена.ГлавныйУзел() = Неопределено Тогда
		
		Запрос = Новый Запрос();
		Запрос.Параметры.Вставить("ЭтотУзел", ПланыОбмена.бит_Полный.ЭтотУзел());
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПланОбменаРИБ.Ссылка
		|ИЗ
		|	ПланОбмена.бит_Полный КАК ПланОбменаРИБ
		|ГДЕ
		|	ПланОбменаРИБ.Ссылка <> &ЭтотУзел";
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Параметры.ОбработкаЗавершена = Истина;
			Возврат;
		КонецЕсли;
		МассивУзлов = Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Метаданные.РегистрыСведений.ПлановыеНачисления);
		ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Метаданные.РегистрыСведений.ПредставленияОснованийУвольнения);
		
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли