﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму загрузки классификатора.
//
// Параметры:
//   Параметры - ПараметрыВыполненияКоманды, Структура - параметры открытия формы.
//
Процедура ЗагрузитьАдресныйКлассификатор(Параметры = Неопределено) Экспорт
	
	ПараметрыОкна = Новый Структура("Уникальность, Окно, НавигационнаяСсылка, Источник", Ложь);
	Если Параметры <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыОкна, Параметры);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	Если ТипЗнч(Параметры) = Тип("Структура") Тогда
		Для Каждого КлючЗначение Из Параметры Цикл
			ПараметрыФормы.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ИмяФормы = "РегистрСведений.АдресныеОбъекты.Форма.ЗагрузкаАдресногоКлассификатора";
	
	ОткрытьФорму(ИмяФормы, ПараметрыФормы,
		ПараметрыОкна.Источник,
		ПараметрыОкна.Уникальность,
		ПараметрыОкна.Окно,
		ПараметрыОкна.НавигационнаяСсылка);
	
КонецПроцедуры

// Открывает форму загрузки адресного классификатора.
//
// Параметры:
//  ОповещениеОЗакрытие - ОписаниеОповещения - оповещение, которое вызывается при закрытии формы загрузки адресного классификатора.
//  ПараметрыФормы - Структура - параметры открытия формы:
//    * КодРегионаДляЗагрузки - Число, Массив - если указан, то регион будет отмечен для загрузки.
//  ПараметрыОткрытия   - Структура - параметры открытия формы:
//    * Владелец            - Произвольный - форма или элемент управления другой формы.
//    * Уникальность        - Произвольный - ключ, значение которого будет использоваться для поиска уже открытых форм.
//    * Окно                - ОкноКлиентскогоПриложения, ВариантОткрытияОкна - окно приложения, в котором будет открыта форма.
//    * НавигационнаяСсылка - Строка - задает навигационную ссылку, возвращаемую формой.
//
Процедура ПоказатьФормуЗагрузкиАдресногоКлассификатора(ОповещениеОЗакрытие = Неопределено, ПараметрыФормы = Неопределено, ПараметрыОткрытия = Неопределено) Экспорт
	
	ПараметрыОткрытияФормы = Новый Структура("Уникальность, Окно, НавигационнаяСсылка, Владелец", Ложь);
	Если ПараметрыОткрытия <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыОткрытияФормы, ПараметрыОткрытия);
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.АдресныеОбъекты.Форма.ЗагрузкаАдресногоКлассификатора", ПараметрыФормы,
		ПараметрыОткрытияФормы.Владелец, ПараметрыОткрытияФормы.Уникальность,
		ПараметрыОткрытияФормы.Окно, ПараметрыОткрытияФормы.НавигационнаяСсылка, ОповещениеОЗакрытие);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОткрытьСведенияОбАдресномКлассификаторе(Параметры, ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	ОткрытьФорму("РегистрСведений.АдресныеОбъекты.Форма.СведенияОбАдресномКлассификаторе", Параметры,,,,, ОписаниеОповещенияОЗакрытии);
КонецПроцедуры

Процедура АвторизоватьНаСайтеПоддержкиПользователей(ОповещениеОЗакрытии, ВладелецФормы) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		
		МодульИнтернетПоддержкаПользователейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтернетПоддержкаПользователейКлиент");
		Если МодульИнтернетПоддержкаПользователейКлиент.ДоступноПодключениеИнтернетПоддержки() Тогда
			МодульИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОповещениеОЗакрытии, ВладелецФормы);
		Иначе
			ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, Неопределено);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызывает диалог выбора каталога.
// 
// Параметры:
//     Форма - ФормаКлиентскогоПриложения - вызывающий объект.
//     ПутьКДанным          - Строка             - полное имя реквизита формы, содержащего текущее значение каталога.
//                                                 Например.
//                                                "РабочийКаталог" или "Объект.КаталогИзображений".
//     Заголовок            - Строка             - Заголовок для диалога.
//     СтандартнаяОбработка - Булево             - для использования в обработчике "ПриНачалаВыбора". Будет заполнено
//                                                 значением Ложь.
//     ОповещениеЗавершения - ОписаниеОповещения - вызывается после успешного помещения нового значения в реквизит.
//
Процедура ВыбратьКаталог(Знач Форма, Знач ПутьКДанным, Знач Заголовок = Неопределено, СтандартнаяОбработка = Ложь, ОповещениеЗавершения = Неопределено) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Форма", Форма);
	Контекст.Вставить("ПутьКДанным", ПутьКДанным);
	Контекст.Вставить("Заголовок", Заголовок);
	Контекст.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	
	ОповещениеПродолжения = Новый ОписаниеОповещения(
		"ВыбратьКаталогЗавершениеОтображенияДиалогаВыбораФайла", 
		ЭтотОбъект, Контекст);
		
	ФайловаяСистемаКлиент.ВыбратьКаталог(ОповещениеПродолжения, Контекст);
	
КонецПроцедуры

Процедура ВыбратьКаталогЗавершениеОтображенияДиалогаВыбораФайла(Каталог, ДополнительныеПараметры) Экспорт
	
	Если Не ПустаяСтрока(Каталог) Тогда
		
		ДополнительныеПараметры.Форма[ДополнительныеПараметры.ПутьКДанным] = Каталог;
		
		Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения, Каталог);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Проверка на доступность всех необходимых файлов для загрузки.
//
// Параметры:
//     КодыРегионов      - Массив    - содержит числовые значения - коды регионов-субъектов РФ (для последующей
//                                     загрузки).
//     Каталог           - Строка    - каталог с проверяемыми файлами.
//     ПараметрыЗагрузки - Структура - содержит поля.
//         * КодИсточникаЗагрузки - Строка - описывает набор анализируемых файлов. Возможные значения: "КАТАЛОГ",
//                                           "САЙТ", "ИТС".
//         * ПолеОшибки           - Строка - имя реквизита для привязки сообщений об ошибке.
//
// Возвращаемое значение: 
//     Структура - описание результата. Содержит поля.
//         * КодыРегионов    - Массив -       содержит числовые значения кодов регионов-субъектов для которых доступны
//                                      все файлы.
//         * ЕстьВсеФайлы    - Булево       - флаг того, что можно загружать все регионы.
//         * Ошибки          - Структура    - см. описание ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю.
//         * ФайлыПоРегионам - Соответствие - соответствие файлов регионам. Ключ может быть:
//                                          - числом (код региона), тогда значение - массив имен файлов, необходимых
//                                          для загрузки этого региона
//                                          - символом "*", тогда значение - массив имен файлов, необходимых для
//                                          загрузки всех регионов.
//
Процедура АнализДоступностиФайловКлассификатораВКаталоге(ОписаниеЗавершения, КодыРегионов, Каталог, ПараметрыЗагрузки) Экспорт
	
	РабочийКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Каталог);
	ПолеОшибки = ПараметрыЗагрузки.ПолеОшибки;
	
	Результат = Новый Структура;
	Результат.Вставить("КодыРегионов",    КодыРегионов);
	Результат.Вставить("ЕстьВсеФайлы",    Истина);
	Результат.Вставить("Ошибки",          Неопределено);
	Результат.Вставить("ФайлыПоРегионам", Новый Соответствие);
	
	ДополнительныеПараметры = ПараметрыЗагрузки();
	ДополнительныеПараметры.ОписаниеЗавершения = ОписаниеЗавершения;
	ДополнительныеПараметры.ПолеОшибки         = ПолеОшибки;
	ДополнительныеПараметры.РабочийКаталог     = РабочийКаталог;
	ДополнительныеПараметры.Результат.КодыРегионов = КодыРегионов;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("АнализДоступностиФайловКлассификатораВКаталогеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, 0);
	
КонецПроцедуры

// Параметры загрузки файлов.
// 
// Возвращаемое значение:
// 	Структура - Содержит:
//   * ИндексРегиона - Неопределено - индекс региона;
//   * ИмяФайла - Строка - Имя файла региона;
//   * КодРегиона - Неопределено -цифровой код региона;
//   * ПолеОшибки - Строка - элементы формы с ошибкой; 
//   * РабочийКаталог - Строка - каталог загрузки файлов адресных сведений;
//   * Результат - Структура - Содержит:
//     ** КодыРегионов - Массив -коды регионов;
//     ** ЕстьВсеФайлы - Булево - признак наличия файлов;
//     ** Ошибки - Массив - список ошибок;
//     ** ФайлыПоРегионам - Соответствие - имя файла и путь к нему. 
//   * ОписаниеЗавершения - Строка - описание завершения;
//   * ОтсутствующиеФайлы - Соответствие - Список отсутствующих файлов.
//
Функция ПараметрыЗагрузки()
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОтсутствующиеФайлы", Новый Соответствие);
	ДополнительныеПараметры.Вставить("ОписаниеЗавершения", "");

	ДополнительныеПараметры.Вставить("РабочийКаталог",     "");
	ДополнительныеПараметры.Вставить("ПолеОшибки",         "");
	
	ДополнительныеПараметры.Вставить("КодРегиона",    Неопределено);
	ДополнительныеПараметры.Вставить("ИмяФайла",      "");
	ДополнительныеПараметры.Вставить("ИндексРегиона", Неопределено);
	
	Результат = Новый Структура;
	Результат.Вставить("КодыРегионов",    Новый Массив);
	Результат.Вставить("ЕстьВсеФайлы",    Истина);
	Результат.Вставить("Ошибки",          Неопределено);
	Результат.Вставить("ФайлыПоРегионам", Новый Соответствие);
	ДополнительныеПараметры.Вставить("Результат",          Результат);
	
	Возврат ДополнительныеПараметры
	
КонецФункции

Процедура АнализДоступностиФайловКлассификатораВКаталогеЗавершение(ИндексРегиона, ДополнительныеПараметры) Экспорт
	
	Если ИндексРегиона <= ДополнительныеПараметры.Результат.КодыРегионов.Количество() - 1 Тогда
		
		КодРегиона = ДополнительныеПараметры.Результат.КодыРегионов.Получить(ИндексРегиона);
		// Набор файлов для каждого региона.
		ДополнительныеПараметры.Результат.ФайлыПоРегионам[КодРегиона.Значение] = Новый Массив;
		
		ИмяФайла = Формат(КодРегиона.Значение, "ЧЦ=2; ЧН=; ЧВН=; ЧГ=") + ".ZIP";
		ДополнительныеПараметры.Вставить("КодРегиона",    КодРегиона.Значение);
		ДополнительныеПараметры.Вставить("ИмяФайла",      ИмяФайла);
		ДополнительныеПараметры.Вставить("ИндексРегиона", ИндексРегиона);
		ОписаниеОповещения = Новый ОписаниеОповещения("АнализДоступностиФайловКлассификатораВКаталогеПослеПоискаФайлов", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПоискФайлов(ОписаниеОповещения, ДополнительныеПараметры.РабочийКаталог, МаскаФайла(ИмяФайла));
		
	Иначе // окончание цикла
		
		Для каждого ОтсутствующийФайл Из ДополнительныеПараметры.ОтсутствующиеФайлы Цикл
			Представление = ДополнительныеПараметры.Результат.КодыРегионов.НайтиПоЗначению(ОтсутствующийФайл.Ключ);
			
			СообщениеОбОшибке = НСтр("ru = 'Для региона ""%1"" не найден файл данных ""%2""'") + Символы.ПС;
			СообщениеОбОшибке = СообщениеОбОшибке + НСтр("ru = 'Актуальные адресные сведения можно загрузить по адресу http://its.1c.ru/download/fias2'");
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(ДополнительныеПараметры.Результат.Ошибки, ДополнительныеПараметры.ПолеОшибки,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, Представление, ОтсутствующийФайл.Значение), Неопределено);
		КонецЦикла;
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеЗавершения, ДополнительныеПараметры.Результат);
		
	КонецЕсли;
	
КонецПроцедуры


// Обработчик оповещения после вызова метода НачатьПоискФайлов
// 
// Параметры:
//   НайденныеФайлы - Массив - файлы с адресными сведениями
//   ДополнительныеПараметры - см. ПараметрыЗагрузки
// 
Процедура АнализДоступностиФайловКлассификатораВКаталогеПослеПоискаФайлов(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	СтруктураФайла = Новый Структура("Существует, Имя, ИмяБезРасширения, ПолноеИмя, Путь, Расширение", Ложь);
	Если НайденныеФайлы.Количество() > 0 Тогда
		
		СтруктураФайла.Существует = Истина;
		ЗаполнитьЗначенияСвойств(СтруктураФайла, НайденныеФайлы[0]);
	КонецЕсли;
	
	Если СтруктураФайла.Существует Тогда
		ДополнительныеПараметры.Результат.ФайлыПоРегионам[ДополнительныеПараметры.КодРегиона].Добавить(СтруктураФайла.ПолноеИмя);
	Иначе
		ДополнительныеПараметры.Результат.ЕстьВсеФайлы = Ложь;
		ДополнительныеПараметры.ОтсутствующиеФайлы.Вставить(ДополнительныеПараметры.КодРегиона, ДополнительныеПараметры.ИмяФайла);
	КонецЕсли;
	
	АнализДоступностиФайловКлассификатораВКаталогеЗавершение(ДополнительныеПараметры.ИндексРегиона + 1, ДополнительныеПараметры);
	
КонецПроцедуры

Функция МаскаФайла(ИмяФайла)
	
	НеУчитыватьРегистр = ОбщегоНазначенияКлиент.ЭтоWindowsКлиент();
	
	Если НеУчитыватьРегистр Тогда
		Маска = ВРег(ИмяФайла);
	Иначе
		Маска = "";
		Для Позиция = 1 По СтрДлина(ИмяФайла) Цикл
			Символ = Сред(ИмяФайла, Позиция, 1);
			ВерхнийРегистр = ВРег(Символ);
			НижнийРегистр  = НРег(Символ);
			Если ВерхнийРегистр = НижнийРегистр Тогда
				Маска = Маска + Символ;
			Иначе
				Маска = Маска + "[" + ВерхнийРегистр + НижнийРегистр + "]";
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Маска;
	
КонецФункции

#КонецОбласти