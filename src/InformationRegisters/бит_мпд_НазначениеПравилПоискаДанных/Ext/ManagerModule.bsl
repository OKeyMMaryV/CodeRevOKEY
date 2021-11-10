﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
	
// Функция получает правила поиска данных для информационной базы источника и приемника.
// 
// Параметры:
//  ВидИБ_Источник - СправочникСсылка.бит_мпд_ВидыИнформационныхБаз
//  ВидИБ_Приемник - СправочникСсылка.бит_мпд_ВидыИнформационныхБаз.
// 
// Возвращаемое значение:
//  ПравилаПоиска - Соответствие.
// 
Функция ПолучитьПравилаПоиска(ВидИБ_Источник ,ВидИБ_Приемник) Экспорт

	ПравилаПоиска = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидИнформационнойБазыИсточник", ВидИБ_Источник);
	Запрос.УстановитьПараметр("ВидИнформационнойБазыПриемник", ВидИБ_Приемник);
	Запрос.Текст = "ВЫБРАТЬ
	               |	НазначениеПравил.ВидИнформационнойБазыИсточник,
	               |	НазначениеПравил.ВидИнформационнойБазыПриемник,
	               |	НазначениеПравил.ИмяОбъектаИсточник КАК ИмяОбъектаИсточник,
	               |	НазначениеПравил.ПравилоПоискаДанных,
	               |	ВЫБОР
	               |		КОГДА НазначениеПравил.ВидИнформационнойБазыПриемник = ЗНАЧЕНИЕ(Справочник.бит_мпд_ВидыИнформационныхБаз.ПустаяСсылка)
	               |			ТОГДА 1
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК Приоритет
	               |ИЗ
	               |	РегистрСведений.бит_мпд_НазначениеПравилПоискаДанных КАК НазначениеПравил
	               |ГДЕ
	               |	НазначениеПравил.ВидИнформационнойБазыИсточник = &ВидИнформационнойБазыИсточник
	               |	И (НазначениеПравил.ВидИнформационнойБазыПриемник = &ВидИнформационнойБазыПриемник
	               |			ИЛИ НазначениеПравил.ВидИнформационнойБазыПриемник = ЗНАЧЕНИЕ(Справочник.бит_мпд_ВидыИнформационныхБаз.ПустаяСсылка))
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ИмяОбъектаИсточник,
	               |	Приоритет";
				   
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();

	Пока Выборка.Следующий() Цикл
	
		Если ПравилаПоиска[Выборка.ИмяОбъектаИсточник] = Неопределено Тогда
		
			 ПравилаПоиска.Вставить(Выборка.ИмяОбъектаИсточник, Выборка.ПравилоПоискаДанных);
		
		КонецЕсли; 
	
	КонецЦикла; 
	
	Возврат ПравилаПоиска;
	
КонецФункции // ПолучитьПравилаПоиска()

#КонецОбласти

#КонецЕсли
