﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
	
// Функция выполняет поиск элемента.
// 
// Параметры:
//   ВидИБ           - СправочникСсылка.бит_мпд_ВидыИнформационныхБаз.
//   Имя             - Строка.
//   ЭтоГруппа       - Булево.
//   ИмяПеречисления - Строка.
// 
// Возвращаемое значение:
//  НайденныйЭлемент - СправочникСсылка.бит_мдм_ЗначенияПеречислений.
// 
Функция НайтиЭлемент(ВидИБ, Имя, ЭтоГруппа, ИмяПеречисления = "") Экспорт

	НайденныйЭлемент = Справочники.бит_мдм_ЗначенияПеречислений.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидИБ"          , ВидИБ);
	Запрос.УстановитьПараметр("ЭтоГруппа"      , ЭтоГруппа);
	Запрос.УстановитьПараметр("Имя"            , Имя);
	Запрос.УстановитьПараметр("ИмяПеречисления", ИмяПеречисления);
	Запрос.Текст = 
    "ВЫБРАТЬ
    |	бит_мдм_ЗначенияПеречислений.Ссылка
    |ИЗ
    |	Справочник.бит_мдм_ЗначенияПеречислений КАК бит_мдм_ЗначенияПеречислений
    |ГДЕ
    |	бит_мдм_ЗначенияПеречислений.Владелец = &ВидИБ
    |	И бит_мдм_ЗначенияПеречислений.ЭтоГруппа = &ЭтоГруппа
    |	И бит_мдм_ЗначенияПеречислений.Имя = &Имя";
	
	Если ЗначениеЗаполнено(ИмяПеречисления) Тогда
	
		Запрос.Текст = Запрос.Текст + " И бит_мдм_ЗначенияПеречислений.Родитель.Имя = &ИмяПеречисления";
	
	КонецЕсли; 			   

    Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
	
		НайденныйЭлемент = Выборка.Ссылка;
	
	КонецЕсли; 
				   
	Возврат НайденныйЭлемент;
	
КонецФункции // НайтиЭлемент()

#КонецОбласти
 
#КонецЕсли
