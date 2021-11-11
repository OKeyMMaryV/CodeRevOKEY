﻿&НаСервере
Перем КонтекстЭДОСервер;

&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("ТранспортноеСообщение") Тогда
		ТранспортноеСообщение = Параметры.Отбор.ТранспортноеСообщение;
		
		// Установка значения отбора в компоновщике настроек.
		ЭлементОтбораДанных = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
		ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТранспортноеСообщение");
		ЭлементОтбораДанных.ПравоеЗначение = ТранспортноеСообщение;
		ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.Использование = Истина;
		
		// Удаление отбора из параметров.
		Параметры.Отбор.Удалить("ТранспортноеСообщение"); 
	КонецЕсли;
	
	Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РегистрСведенийСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	// определяем транспортное сообщение
	ТранспортноеСообщение = Неопределено;
	
	Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
	ЭлементыСписка = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы;
	
	Для Каждого Эл Из ЭлементыСписка Цикл
		Если Эл.Использование И ТипЗнч(Эл.ПравоеЗначение) = Тип("ДокументСсылка.ТранспортноеСообщение") Тогда
			ТранспортноеСообщение = Эл.ПравоеЗначение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	// если транспортное сообщение не задано, то сообщаем и прерываемся
	Если ТранспортноеСообщение = Неопределено ИЛИ НЕ ЗначениеЗаполнено(ТранспортноеСообщение) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не установлен отбор по транспортным сообщениям!'"));
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("ТранспортноеСообщение", ТранспортноеСообщение);
	ОписаниеОповещения 		= Новый ОписаниеОповещения("РегистрСведенийСписокПередНачаломДобавленияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстСообщения = ОперацииСФайламиЭДКОКлиент.ТекстСообщенияДляНеобязательнойУстановкиРасширенияРаботыСФайлами();;
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(ОписаниеОповещения, ТекстСообщения, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыгрузить(Команда)
	
	ТекСтроки = Элементы.РегистрСведенийСписок.ВыделенныеСтроки;
	Если ТекСтроки.Количество() <> 0 Тогда
		
		Если НЕ ПолучитьДанныеНаСервере(ТекСтроки) ИЛИ ВыборкаСодержимого.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		Всего = 0;
		ВАрхиве = 0;
		Для Каждого Контейнер Из ВыборкаСодержимого Цикл 
			Всего = Всего + 1;
			Если Контейнер.ВАрхиве Тогда 
				ВАрхиве = ВАрхиве + 1;
			КонецЕсли;
		КонецЦикла; 
		
		Если ВАрхиве > 0 Тогда
			ОписаниеОповещения  = ?(ВАрхиве = Всего, Неопределено, Новый ОписаниеОповещения("КомандаВыгрузитьПродолжение", ЭтотОбъект));
			КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(ОписаниеОповещения, 25 + ?(ВАрхиве > 1, 1, 0), 0, ВАрхиве = Всего);
			Возврат;
		КонецЕсли;
		
		КомандаВыгрузитьПродолжение(КодВозвратаДиалога.Да, Неопределено);
	    				
	Иначе
		
		ПоказатьПредупреждение(, "Выберите файлы, которые следует сохранить на диск, и повторите попытку.
		|Для множественного выбора используйте клавишу Ctrl.");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыгрузитьПродолжение(Результат, ВхПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	
	МассивИменФайлов = Новый Массив;
	МассивОписанийПолучаемыеФайлы = Новый Массив;
	Для Каждого Контейнер Из ВыборкаСодержимого Цикл 
		Если Контейнер.ВАрхиве Тогда
			Продолжить;
		КонецЕсли;
		МассивИменФайлов.Добавить(Контейнер.КороткоеИмяФайла);
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(Контейнер.КороткоеИмяФайла, Контейнер.АдресСодержимого); 
		МассивОписанийПолучаемыеФайлы.Добавить(ОписаниеФайла);
	КонецЦикла;
	
	ОперацииСФайламиЭДКОКлиент.СохранитьФайлы(МассивОписанийПолучаемыеФайлы);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОчиститьТаблицуИХранилище()
	
	Если ВыборкаСодержимого.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Выборка Из ВыборкаСодержимого Цикл 
		УдалитьИзВременногоХранилища(Выборка.АдресСодержимого);
	КонецЦикла;
	
	ВыборкаСодержимого.Очистить();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеНаСервере(ТекСтроки)
	
	Если КонтекстЭДОСервер = Неопределено Тогда 
		// инициализируем контекст ЭДО - модуль обработки
		ТекстСообщения = "";
		КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
		Если КонтекстЭДОСервер = Неопределено Тогда 
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ОчиститьТаблицуИХранилище();
	
	Сообщения = Новый Массив;
	Для Каждого ТекСтрока Из ТекСтроки Цикл
		Сообщения.Добавить(ТекСтрока.ТранспортноеСообщение);
	КонецЦикла;
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	ТранспортныеКонтейнеры.ТранспортноеСообщение,
	                      |	ТранспортныеКонтейнеры.Данные,
	                      |	ТранспортныеКонтейнеры.ИмяФайла
						  |	, ВЫБОР
						  |		КОГДА СостояниеОбъектов.Архивный ЕСТЬ NULL ТОГДА Ложь
						  |		КОГДА СостояниеОбъектов.Архивный = Ложь ТОГДА Ложь
						  |	ИНАЧЕ
						  |		Истина
						  |	КОНЕЦ ВАрхиве
	                      |ИЗ
	                      |	РегистрСведений.ТранспортныеКонтейнеры КАК ТранспортныеКонтейнеры
						  |
						  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПризнакиАрхивированияФайловДОСКонтролирующимиОрганами КАК СостояниеОбъектов
						  |			ПО 		(СостояниеОбъектов.Объект = ТранспортныеКонтейнеры.ТранспортноеСообщение)
						  |				И	(СостояниеОбъектов.ИмяФайла = ТранспортныеКонтейнеры.ИмяФайла)
						  |				И	(СостояниеОбъектов.Владелец = Значение(Перечисление.ВидыАрхивируемыхМетаданныхДО.ТранспортныеКонтейнеры))
						  |
	                      |ГДЕ
	                      |	ТранспортныеКонтейнеры.ТранспортноеСообщение В(&ТранспортноеСообщение)");
	Запрос.УстановитьПараметр("ТранспортноеСообщение", Сообщения);
	Выборка = Запрос.Выполнить().Выгрузить();
	
	ТранспортныеСообщенияСПрисоединеннымиФайлами = Новый Массив;
	Для Каждого ЭлементВыборки Из Выборка Цикл
		Если ЭлементВыборки.Данные.Получить() = Неопределено
			И ТранспортныеСообщенияСПрисоединеннымиФайлами.Найти(ЭлементВыборки.ТранспортноеСообщение) = Неопределено Тогда
			ТранспортныеСообщенияСПрисоединеннымиФайлами.Добавить(ЭлементВыборки.ТранспортноеСообщение);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаФайлов = Неопределено;
	Если ТранспортныеСообщенияСПрисоединеннымиФайлами.Количество() > 0 Тогда
		ТаблицаФайлов = ОбщегоНазначенияЭДКО.ПрикрепленныеФайлыКОбъектуИзСправочника(
			ТранспортныеСообщенияСПрисоединеннымиФайлами,
			"ТранспортноеСообщениеКонтейнерыПрисоединенныеФайлы",
			,
			"ВладелецФайла, ИсходноеИмяФайла");
		
		Для каждого СтрокаТаблицы Из ТаблицаФайлов Цикл
			СтрокаТаблицы.ИсходноеИмяФайла = ВРЕГ(СтрокаТаблицы.ИсходноеИмяФайла);
		КонецЦикла;
	КонецЕсли;
	
	Для каждого ЭлементВыборки Из Выборка Цикл
		НоваяСтрока = ВыборкаСодержимого.Добавить();
		ГУИД = Новый УникальныйИдентификатор;
		НоваяСтрока.КороткоеИмяФайла = ЭлементВыборки.ИмяФайла;
		НоваяСтрока.ВАрхиве = ЭлементВыборки.ВАрхиве;
		
		ДанныеТранспортногоКонтейнера = ЭлементВыборки.Данные.Получить();
		Если ДанныеТранспортногоКонтейнера = Неопределено Тогда
			ИсходноеИмяФайла = ВРЕГ(ЭлементВыборки.ИмяФайла);
			
			ПараметрыОтбора = Новый Структура("ВладелецФайла, ИсходноеИмяФайла",
				ЭлементВыборки.ТранспортноеСообщение, ИсходноеИмяФайла);
			СтрокиТаблицы = ТаблицаФайлов.НайтиСтроки(ПараметрыОтбора);
			Если СтрокиТаблицы.Количество() > 0 Тогда
				ДанныеТранспортногоКонтейнера = РаботаСФайлами.ДвоичныеДанныеФайла(СтрокиТаблицы[0].Ссылка);
			КонецЕсли;
		КонецЕсли;
		НоваяСтрока.АдресСодержимого = ПоместитьВоВременноеХранилище(ДанныеТранспортногоКонтейнера, ГУИД);
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрСведенийСписокПередНачаломДобавленияЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		ДобавитьТранспортныйКонтейнерПослеУстановкиРасширенияРаботыСФайлами(ДополнительныеПараметры.ТранспортноеСообщение)
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьТранспортныйКонтейнерПослеУстановкиРасширенияРаботыСФайлами(ТранспортноеСообщение)
	
	// помещаем файл во временное хранилище
	АдресКонтейнераВоВременномХранилище = "";
	ПолноеИмяФайлаФайла = "";
	
	ДополнительныеПараметры = Новый Структура("ТранспортноеСообщение", ТранспортноеСообщение);
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьТранспортныйКонтейнерПослеУстановкиРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПомещениеФайла(ОписаниеОповещения, АдресКонтейнераВоВременномХранилище, ПолноеИмяФайлаФайла, Истина, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьТранспортныйКонтейнерПослеУстановкиРасширенияРаботыСФайламиЗавершение(Результат, АдресКонтейнераВоВременномХранилище, ПолноеИмяФайлаФайла, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	ТранспортноеСообщение = ДополнительныеПараметры.ТранспортноеСообщение;
	
	// Каталог получаем из полного имени файла.
	ОбъектФайл = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПолноеИмяФайлаФайла);
	
	// определяем, есть ли уже контейнеры у сообщения
	ТранспортныеКонтейнеры = КонтекстЭДОКлиент.ПолучитьИменаТранспортныхКонтейнеров(ТранспортноеСообщение);
	КоличествоТранспортныхКонтейнеров = ТранспортныеКонтейнеры.Количество();
	Если КоличествоТранспортныхКонтейнеров > 0 Тогда
		
		// если контейнер с тем же именем, что выбранный, уже присутствует в базе, то предупреждаем, что он будет заменен
		КонтейнерСТемЖеИменемСуществует = (ТранспортныеКонтейнеры.Найти(ОбъектФайл.Имя) <> Неопределено);
		Если КонтейнерСТемЖеИменемСуществует Тогда
			
			ДополнительныеПараметры = Новый Структура();
			ДополнительныеПараметры.Вставить("КоличествоТранспортныхКонтейнеров",   КоличествоТранспортныхКонтейнеров);
			ДополнительныеПараметры.Вставить("КонтейнерСТемЖеИменемСуществует",     КонтейнерСТемЖеИменемСуществует);
			ДополнительныеПараметры.Вставить("ТранспортноеСообщение",               ТранспортноеСообщение);
			ДополнительныеПараметры.Вставить("ОбъектФайл",                          ОбъектФайл);
			ДополнительныеПараметры.Вставить("АдресКонтейнераВоВременномХранилище", АдресКонтейнераВоВременномХранилище);
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ВопросДобавитьТранспортныйКонтейнерЗаменитьСуществующийЗавершение", ЭтотОБъект, ДополнительныеПараметры);
			
			ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Загружаемый контейнер заменит существующий с тем же именем. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
		Иначе
			УдалитьПрочиеКонтейнерыТранспортногоСообщения(
				КоличествоТранспортныхКонтейнеров, 
				КонтейнерСТемЖеИменемСуществует, 
				ТранспортноеСообщение, 
				ОбъектФайл, 
				АдресКонтейнераВоВременномХранилище);
		КонецЕсли;
		
	Иначе
		// добавляем новый контейнер
		КонтекстЭДОКлиент.ДобавитьТранспортныйКонтейнер(ТранспортноеСообщение, АдресКонтейнераВоВременномХранилище, ОбъектФайл.Имя);
		
		// обновляем форму списка
		Элементы.РегистрСведенийСписок.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросДобавитьТранспортныйКонтейнерЗаменитьСуществующийЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	КоличествоТранспортныхКонтейнеров = ДополнительныеПараметры.КоличествоТранспортныхКонтейнеров;
	КонтейнерСТемЖеИменемСуществует = ДополнительныеПараметры.КонтейнерСТемЖеИменемСуществует;
	ТранспортноеСообщение = ДополнительныеПараметры.ТранспортноеСообщение;
	ОбъектФайл = ДополнительныеПараметры.ОбъектФайл;
	АдресКонтейнераВоВременномХранилище = ДополнительныеПараметры.АдресКонтейнераВоВременномХранилище;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		УдалитьПрочиеКонтейнерыТранспортногоСообщения(КоличествоТранспортныхКонтейнеров, КонтейнерСТемЖеИменемСуществует, ТранспортноеСообщение, ОбъектФайл, АдресКонтейнераВоВременномХранилище);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПрочиеКонтейнерыТранспортногоСообщения(КоличествоТранспортныхКонтейнеров, КонтейнерСТемЖеИменемСуществует, ТранспортноеСообщение, ОбъектФайл, АдресКонтейнераВоВременномХранилище)
	
	// если контейнеров после загрузки станет больше одного, то предлагаем очистить контейнеры сообщения перед загрузкой
	Если КоличествоТранспортныхКонтейнеров - ?(КонтейнерСТемЖеИменемСуществует, 1, 0) > 0 Тогда
		
		ДополнительныеПараметры = Новый Структура("ТранспортноеСообщение, АдресКонтейнераВоВременномХранилище, ОбъектФайл", 
			ТранспортноеСообщение, АдресКонтейнераВоВременномХранилище, ОбъектФайл);
			
		ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьПрочиеКонтейнерыТранспортногоСообщенияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Удалить прочие контейнеры транспортного сообщения?'"), РежимДиалогаВопрос.ДаНетОтмена);
	Иначе
		// добавляем новый контейнер
		КонтекстЭДОКлиент.ДобавитьТранспортныйКонтейнер(ТранспортноеСообщение, АдресКонтейнераВоВременномХранилище, ОбъектФайл.Имя);
		
		// обновляем форму списка
		Элементы.РегистрСведенийСписок.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПрочиеКонтейнерыТранспортногоСообщенияЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	ТранспортноеСообщение = ДополнительныеПараметры.ТранспортноеСообщение;
	АдресКонтейнераВоВременномХранилище = ДополнительныеПараметры.АдресКонтейнераВоВременномХранилище;
	ОбъектФайл = ДополнительныеПараметры.ОбъектФайл;
		
	Если Ответ = КодВозвратаДиалога.Да Тогда
		КонтекстЭДОКлиент.УдалитьТранспортныйКонтейнер(ТранспортноеСообщение);
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	// добавляем новый контейнер
	КонтекстЭДОКлиент.ДобавитьТранспортныйКонтейнер(ТранспортноеСообщение, АдресКонтейнераВоВременномХранилище, ОбъектФайл.Имя);
	
	// обновляем форму списка
	Элементы.РегистрСведенийСписок.Обновить();
	
КонецПроцедуры

#КонецОбласти

